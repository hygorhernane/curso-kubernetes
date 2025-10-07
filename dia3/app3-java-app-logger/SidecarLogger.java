// SidecarLogger.java
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

public class SidecarLogger {

    public static void main(String[] args) {
        System.out.println("Sidecar Logger iniciado.");
        
        // Define o caminho do arquivo de saída a partir da variável de ambiente
        // CRÍTICO: Este deve ser o caminho do volume compartilhado.
        String filePath = System.getenv("SIDECAR_FILE_PATH");
        if (filePath == null || filePath.isEmpty()) {
            System.err.println("Erro: SIDECAR_FILE_PATH não configurado.");
            System.exit(1);
        }

        System.out.println("Salvando variáveis de ambiente em: " + filePath);

        try (PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
            
            writer.println("--- VARIÁVEIS DE AMBIENTE REGISTRADAS ---");
            
            // Itera sobre todas as variáveis de ambiente do sistema
            Map<String, String> env = System.getenv();
            
            // Filtra e salva as variáveis de interesse
            for (Map.Entry<String, String> entry : env.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                
                // Exemplo: Salva apenas as variáveis que vieram do Secret e ConfigMap
                if (key.startsWith("APP_") || key.startsWith("SECRET_")) {
                    writer.printf("%s: %s%n", key, value);
                }
            }
            
            writer.println("------------------------------------------");
            writer.println("Log criado em: " + new java.util.Date());
            
            System.out.println("Registro concluído. O Sidecar irá agora para sleep e manter o arquivo aberto.");
            
            // Mantém o container rodando indefinidamente após salvar o arquivo
            // Isso é CRÍTICO para o Deployment.
            while (true) {
                Thread.sleep(60000); // Sleep por 1 minuto
            }
            
        } catch (IOException e) {
            System.err.println("Erro de E/S ao escrever o arquivo: " + e.getMessage());
        } catch (InterruptedException e) {
             System.err.println("Sidecar interrompido.");
        }
    }
}
