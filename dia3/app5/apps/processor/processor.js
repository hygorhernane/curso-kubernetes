const fs = require('fs').promises;
const path = require('path');
const chokidar = require('chokidar');

// Configurações (virão do ConfigMap e Secret)
const RAW_METRICS_DIR = process.env.RAW_METRICS_DIR || '/app-data/raw';
const PROCESSED_METRICS_DIR = process.env.PROCESSED_METRICS_DIR || '/app-data/processed';
const SECRET_KEY = process.env.SECRET_KEY || 'default-secret';

async function processMetric(filePath) {
  console.log(`Processing new metric: ${filePath}`);
  try {
    const data = await fs.readFile(filePath, 'utf8');
    const metric = JSON.parse(data);

    // Simula uma validação ou enriquecimento usando um segredo
    if (!SECRET_KEY) {
      throw new Error('SECRET_KEY is not defined!');
    }
    metric.processedAt = new Date().toISOString();
    metric.validatedBy = SECRET_KEY.substring(0, 4) + '...';

    const newFilePath = path.join(PROCESSED_METRICS_DIR, path.basename(filePath));
    await fs.writeFile(newFilePath, JSON.stringify(metric, null, 2));
    
    // Remove o arquivo original
    await fs.unlink(filePath);
    console.log(`Moved processed metric to: ${newFilePath}`);

  } catch (error) {
    console.error(`Failed to process metric ${filePath}:`, error);
    // Mover para um diretório de erro seria uma boa prática
  }
}

async function main() {
  console.log('Processor starting...');
  console.log(`Watching for raw metrics in: ${RAW_METRICS_DIR}`);
  console.log(`Moving processed metrics to: ${PROCESSED_METRICS_DIR}`);

  // Garante que os diretórios existam
  await fs.mkdir(RAW_METRICS_DIR, { recursive: true });
  await fs.mkdir(PROCESSED_METRICS_DIR, { recursive: true });

  // Usa chokidar para observar o diretório de forma eficiente
  const watcher = chokidar.watch(RAW_METRICS_DIR, {
    ignored: /^\./,
    persistent: true,
    ignoreInitial: true,
  });

  watcher
    .on('add', processMetric)
    .on('error', error => console.error('Watcher error:', error));
  
  console.log('Watcher is ready.');
}

main();
