// ReaderController.java
package com.meuapp.web;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Value;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.IOException;

@RestController
public class ReaderController {

    // Injeta o caminho do arquivo do volume compartilhado
    @Value("${app.config.file.path}")
    private String configFilePath;

    // Injeta o título da aplicação do ConfigMap (apenas para demonstração)
    @Value("${app.title}")
    private String appTitle;

    @GetMapping("/")
    public String readLog() {
        String logContent;
        String htmlContent;

        try {
            // Tenta ler o conteúdo do arquivo criado pelo Sidecar
            logContent = new String(Files.readAllBytes(Paths.get(configFilePath)));
        } catch (IOException e) {
            logContent = "ERRO: Não foi possível ler o arquivo em " + configFilePath + ". O Sidecar salvou o arquivo?";
        }

        // Formata a saída HTML
        htmlContent = "<html><body>"
                    + "<h1>" + appTitle + "</h1>"
                    + "<h2>Variáveis Injetadas pelo Sidecar:</h2>"
                    + "<pre>" + logContent.replace("<", "&lt;").replace(">", "&gt;") + "</pre>"
                    + "</body></html>";
        
        return htmlContent;
    }
    
    // Endpoint de saúde
    @GetMapping("/healthz")
    public String healthz() {
        return "OK";
    }
}
