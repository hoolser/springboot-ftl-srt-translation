package com.tasos.demo.opensearch;

import org.apache.hc.client5.http.auth.AuthScope;
import org.apache.hc.client5.http.auth.UsernamePasswordCredentials;
import org.apache.hc.client5.http.impl.auth.BasicCredentialsProvider;
import org.apache.hc.client5.http.impl.nio.PoolingAsyncClientConnectionManagerBuilder;
import org.apache.hc.client5.http.ssl.ClientTlsStrategyBuilder;
import org.apache.hc.client5.http.ssl.NoopHostnameVerifier;
import org.apache.hc.client5.http.ssl.TrustAllStrategy;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.nio.ssl.TlsStrategy;
import org.apache.hc.core5.ssl.SSLContextBuilder;
import org.opensearch.client.json.jackson.JacksonJsonpMapper;
import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.transport.httpclient5.ApacheHttpClient5Transport;
import org.opensearch.client.transport.httpclient5.ApacheHttpClient5TransportBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.net.ssl.SSLContext;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;

@Configuration
@ConditionalOnProperty(name = "opensearch.enabled", havingValue = "true")
public class OpenSearchConfig {

    @Value("${opensearch.host:localhost}")
    private String host;

    @Value("${opensearch.port:9200}")
    private int port;

    @Value("${opensearch.scheme:https}")
    private String scheme;

    @Value("${opensearch.username:admin}")
    private String username;

    @Value("${opensearch.password:admin}")
    private String password;

    @Bean
    public OpenSearchClient openSearchClient() throws NoSuchAlgorithmException, KeyStoreException, KeyManagementException {
        final BasicCredentialsProvider credentialsProvider = new BasicCredentialsProvider();
        credentialsProvider.setCredentials(new AuthScope(host, port),
                new UsernamePasswordCredentials(username, password.toCharArray()));

        // Skip SSL cert verification since it's an internal VM with likely self-signed cert
        SSLContext sslContext = SSLContextBuilder.create()
                .loadTrustMaterial(new TrustAllStrategy())
                .build();

        final TlsStrategy tlsStrategy = ClientTlsStrategyBuilder.create()
                .setSslContext(sslContext)
                .setHostnameVerifier(NoopHostnameVerifier.INSTANCE)
                .build();

        ApacheHttpClient5Transport transport = ApacheHttpClient5TransportBuilder
                .builder(new HttpHost(scheme, host, port))
                .setMapper(new JacksonJsonpMapper())
                .setHttpClientConfigCallback(httpClientBuilder -> httpClientBuilder
                        .setDefaultCredentialsProvider(credentialsProvider)
                        .setConnectionManager(
                                PoolingAsyncClientConnectionManagerBuilder.create()
                                        .setTlsStrategy(tlsStrategy)
                                        .build()
                        )
                )
                .build();

        return new OpenSearchClient(transport);
    }
}

