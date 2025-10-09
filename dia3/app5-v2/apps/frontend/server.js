const express = require('express');
const fs = require('fs').promises;
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Configurações do App (virão do ConfigMap)
const DASHBOARD_DATA_PATH = process.env.DASHBOARD_DATA_PATH || '/dashboard-data/summary.json';
const APP_TITLE = process.env.APP_TITLE || 'App5 - Painel de Métricas';

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Endpoint de Health Check
app.get('/healthz', (req, res) => res.status(200).send('OK'));

// Rota principal que renderiza o painel
app.get('/', async (req, res) => {
  let summary = {
    totalMetrics: 0,
    averageValue: 0,
    lastUpdated: new Date().toUTCString(),
    error: null
  };

  try {
    // Lê o arquivo de sumário gerado pelo agregador
    const data = await fs.readFile(DASHBOARD_DATA_PATH, 'utf8');
    summary = { ...summary, ...JSON.parse(data) };
  } catch (error) {
    console.error("Could not read summary file:", error.message);
    summary.error = `Aguardando dados do agregador... (não foi possível ler ${DASHBOARD_DATA_PATH})`;
  }

  res.render('index', { title: APP_TITLE, summary });
});

app.listen(PORT, () => {
  console.log(`Frontend server running on port ${PORT}`);
  console.log(`Reading summary from: ${DASHBOARD_DATA_PATH}`);
});
