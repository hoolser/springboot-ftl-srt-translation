package com.tasos.demo.opensearch;

import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.opensearch.core.IndexRequest;
import org.opensearch.client.opensearch.core.SearchRequest;
import org.opensearch.client.opensearch.core.SearchResponse;
import org.opensearch.client.opensearch.core.CountRequest;
import org.opensearch.client.opensearch.core.CountResponse;
import org.opensearch.client.opensearch.core.GetRequest;
import org.opensearch.client.opensearch.core.GetResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Service
@ConditionalOnProperty(name = "opensearch.enabled", havingValue = "true")
public class VibeService {

    private static final Logger logger = LoggerFactory.getLogger(VibeService.class);
    private static final String INDEX_NAME = "vibe";

    @Autowired
    private OpenSearchClient openSearchClient;

    public List<Vibe> getAllVibes() {
        try {
            SearchRequest searchRequest = new SearchRequest.Builder()
                    .index(INDEX_NAME)
                    .query(q -> q.matchAll(m -> m))
                    .size(100) // Getting up to 100 vibes for listing
                    .build();
            SearchResponse<Vibe> response = openSearchClient.search(searchRequest, Vibe.class);
            return response.hits().hits().stream()
                    .map(hit -> hit.source())
                    .collect(Collectors.toList());
        } catch (Exception e) {
            logger.error("Could not fetch all vibes", e);
            return List.of();
        }
    }

    public void createVibe(Vibe vibe) throws IOException {
        long currentCount = 0;
        try {
            CountRequest countReq = new CountRequest.Builder().index(INDEX_NAME).build();
            CountResponse countRes = openSearchClient.count(countReq);
            currentCount = countRes.count();
        } catch (Exception e) {
            logger.warn("Could not get count for index {}", INDEX_NAME, e);
        }

        String newId = String.valueOf(currentCount + 1);
        vibe.setId(newId);

        IndexRequest<Vibe> request = new IndexRequest.Builder<Vibe>()
                .index(INDEX_NAME)
                .id(vibe.getId())
                .document(vibe)
                .build();
        openSearchClient.index(request);
        logger.info("Successfully created vibe with id: {}", vibe.getId());
    }

    public Vibe getRandomVibe() {
        try {
            CountRequest countReq = new CountRequest.Builder().index(INDEX_NAME).build();
            CountResponse countRes = openSearchClient.count(countReq);
            long total = countRes.count();

            if (total > 0) {
                long randomId = (long)(Math.random() * total) + 1;
                GetRequest getReq = new GetRequest.Builder()
                        .index(INDEX_NAME)
                        .id(String.valueOf(randomId))
                        .build();
                GetResponse<Vibe> getRes = openSearchClient.get(getReq, Vibe.class);
                if (getRes.found()) {
                    return getRes.source();
                }
            }
        } catch (Exception e) {
            logger.warn("OpenSearch is down or unavailable for random vibe: {}", e.getMessage());
        }
        return null;
    }
}
