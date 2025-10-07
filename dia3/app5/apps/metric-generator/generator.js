const fs = require('fs').promises;
const path = require('path');
const { v4: uuidv4 } = require('uuid');

// Configurações (virão do ConfigMap)
const RAW_METRICS_DIR = process.env.RAW_METRICS_DIR || '/app-data/raw';
const GENERATION_INTERVAL_MS = parseInt(process.env.GENERATION_INTERVAL_MS, 10) || 5000;

async function generateMetric() {
  const metric = {
    id: uuidv4(),
    value: parseFloat((Math.random() * 100).toFixed(2)),
    timestamp: new Date().toISOString()
  };

  const filePath = path.join(RAW_METRICS_DIR, `${metric.id}.json`);

  try {
    await fs.writeFile(filePath, JSON.stringify(metric, null, 2));
    console.log(`Generated metric: ${filePath}`);
  } catch (error) {
    console.error(`Error writing metric to ${filePath}:`, error);
  }
}

async function main() {
  console.log('Metric Generator starting...');
  console.log(`Writing raw metrics to: ${RAW_METRICS_DIR}`);
  console.log(`Generation interval: ${GENERATION_INTERVAL_MS}ms`);

  // Garante que o diretório exista
  await fs.mkdir(RAW_METRICS_DIR, { recursive: true });

  setInterval(generateMetric, GENERATION_INTERVAL_MS);
}

main();
