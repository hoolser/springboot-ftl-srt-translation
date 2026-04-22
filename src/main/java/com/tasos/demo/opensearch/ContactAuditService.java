package com.tasos.demo.opensearch;

import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.opensearch.core.IndexRequest;
import org.opensearch.client.opensearch.core.SearchRequest;
import org.opensearch.client.opensearch.core.SearchResponse;
import org.opensearch.client.opensearch.core.DeleteByQueryRequest;
import org.opensearch.client.opensearch.core.DeleteByQueryResponse;
import org.opensearch.client.opensearch._types.query_dsl.MatchQuery;
import org.opensearch.client.opensearch._types.query_dsl.Query;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@ConditionalOnProperty(name = "opensearch.enabled", havingValue = "true")
public class ContactAuditService {

    private static final Logger logger = LoggerFactory.getLogger(ContactAuditService.class);
    private static final String INDEX_NAME = "contact_audit";
    private static final int MAX_EMAILS_PER_IP = 3; // Hard limit

    @Autowired(required = false)
    private OpenSearchClient openSearchClient;

    /**
     * Checks if the given IP is allowed to send an email.
     * Throws an exception if the database is down or the limit is reached.
     */
    public void validateAndRecordIp(String ipAddress) throws Exception {
        if (openSearchClient == null) {
            throw new RuntimeException("OpenSearch is not available. Contact forms are currently disabled.");
        }

        try {
            // Force index creation check implicitly or explicitly if needed,
            // but relying on dynamic mapping for now is fine for simple audits.

            // 1. Query the index for this IP
            Query query = new Query.Builder()
                    .match(new MatchQuery.Builder()
                            .field("ip_address.keyword")
                            .query(fb -> fb.stringValue(ipAddress))
                            .build())
                    .build();

            SearchRequest searchRequest = new SearchRequest.Builder()
                    .index(INDEX_NAME)
                    .query(query)
                    .build();

            SearchResponse<Map> searchResponse = openSearchClient.search(searchRequest, Map.class);
            long pastRequests = searchResponse.hits().total().value();

            if (pastRequests >= MAX_EMAILS_PER_IP) {
                logger.warn("IP {} reached its contact limit of {}.", ipAddress, MAX_EMAILS_PER_IP);
                throw new RuntimeException("You have reached the maximum allowed limit of " + MAX_EMAILS_PER_IP + " emails. Try again later.");
            }

            // 2. Record the IP hit
            Map<String, Object> document = new HashMap<>();
            document.put("ip_address", ipAddress);
            document.put("timestamp", LocalDateTime.now().toString());

            IndexRequest<Map<String, Object>> indexRequest = new IndexRequest.Builder<Map<String, Object>>()
                    .index(INDEX_NAME)
                    .id(UUID.randomUUID().toString())
                    .document(document)
                    .build();

            openSearchClient.index(indexRequest);
            logger.info("Recorded contact form usage for IP: {}", ipAddress);

        } catch (IOException e) {
            logger.error("Failed to connect to OpenSearch: {}", e.getMessage());
            throw new RuntimeException("Contact service is temporarily unavailable. Please try again later.");
        }
    }

    /**
     * Resets the limit for a specific IP by deleting its records from the index.
     */
    public void resetIpLimit(String ipAddress) throws Exception {
        if (openSearchClient == null) {
            throw new RuntimeException("OpenSearch is not available.");
        }

        try {
            Query query = new Query.Builder()
                    .match(new MatchQuery.Builder()
                            .field("ip_address.keyword")
                            .query(fb -> fb.stringValue(ipAddress))
                            .build())
                    .build();

            DeleteByQueryRequest deleteRequest = new DeleteByQueryRequest.Builder()
                    .index(INDEX_NAME)
                    .query(query)
                    .build();

            DeleteByQueryResponse response = openSearchClient.deleteByQuery(deleteRequest);
            logger.info("Reset limit for IP: {}. Deleted {} records.", ipAddress, response.deleted());
        } catch (IOException e) {
            logger.error("Failed to delete by query from OpenSearch: {}", e.getMessage());
            throw new RuntimeException("Failed to reset IP limit.");
        }
    }
}
