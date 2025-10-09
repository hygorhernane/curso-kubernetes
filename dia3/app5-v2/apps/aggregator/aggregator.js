const fs = require('fs').promises;
const path = require('path');

// Configurações (virão do ConfigMap)
const PROCESSED_METRICS_DIR = process.env.PROCESSED_METRICS_DIR || '/app-data/processed';
const DASHBOARD_DATA_PATH = process.env.DASHBOARD_DATA_PATH || '/dashboard-data/summary.json';
const AGGREGATION_INTERVAL_MS = parseInt(process.env.AGGREGATION_INTERVAL_MS, 10) || 10000;

async function aggregateMetrics() {
  console.log('Running aggregation...');
  try {
    const files = await fs.readdir(PROCESSED_METRICS_DIR);
    const jsonFiles = files.filter(file => path.extname(file) === '.json');

    let totalValue = 0;
    let totalMetrics = jsonFiles.length;

    for (const file of jsonFiles) {
      const filePath = path.join(PROCESSED_METRICS_DIR, file);
      const data = await fs.readFile(filePath, 'utf8');
      const metric = JSON.parse(data);
      totalValue += metric.value;
    }

    const summary = {
      totalMetrics: totalMetrics,
      averageValue: totalMetrics > 0 ? totalValue / totalMetrics : 0,
      lastUpdated: new Date().toISOString()
    };

    await fs.writeFile(DASHBOARD_DATA_PATH, JSON.stringify(summary, null, 2));
    console.log(`Aggregation complete. Summary written to ${DASHBOARD_DATA_PATH}`);

  } catch (error) {
    if (error.code === 'ENOENT') {
      console.log(`Directory ${PROCESSED_METRICS_DIR} not found. Waiting for processor to create it.`);
    } else {
      console.error('Error during aggregation:', error);
    }
  }
}

async function main() {
  console.log('Aggregator starting...');
  console.log(`Reading processed metrics from: ${PROCESSED_METRICS_DIR}`);
  console.log(`Writing summary to: ${DASHBOARD_DATA_PATH}`);
  console.log(`Aggregation interval: ${AGGREGATION_INTERVAL_MS}ms`);
  
  // Garante que o diretório de destino exista
  await fs.mkdir(path.dirname(DASHBOARD_DATA_PATH), { recursive: true });

  setInterval(aggregateMetrics, AGGREGATION_INTERVAL_MS);
}

main();
