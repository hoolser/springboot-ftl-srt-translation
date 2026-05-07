package com.tasos.demo.opensearch;

import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.opensearch.core.IndexRequest;
import org.opensearch.client.opensearch.core.SearchRequest;
import org.opensearch.client.opensearch.core.SearchResponse;
import org.opensearch.client.opensearch.core.CountRequest;
import org.opensearch.client.opensearch.core.CountResponse;
import org.opensearch.client.opensearch.core.GetRequest;
import org.opensearch.client.opensearch.core.GetResponse;
import org.opensearch.client.opensearch.core.BulkRequest;
import org.opensearch.client.opensearch.core.BulkResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.List;
import java.util.stream.Collectors;

@Service
@ConditionalOnProperty(name = "opensearch.enabled", havingValue = "true")
public class VibeService {

    private static final Logger logger = LoggerFactory.getLogger(VibeService.class);
    private static final String INDEX_NAME = "vibe";

    @Autowired
    private OpenSearchClient openSearchClient;

    public void deleteVibe(String id) throws IOException {
        openSearchClient.delete(d -> d.index(INDEX_NAME).id(id));
        logger.info("Successfully deleted vibe with id: {}", id);
    }

    public void reindexVibes() {
        try {
            List<Vibe> allVibes = getAllVibes(); // Gets up to 100 or all
            // Sort to preserve order somewhat?
            allVibes.sort((v1, v2) -> {
                try {
                    return Integer.compare(Integer.parseInt(v1.getId()), Integer.parseInt(v2.getId()));
                } catch (Exception e) {
                    return 0;
                }
            });

            // Delete index
            try {
                openSearchClient.indices().delete(d -> d.index(INDEX_NAME));
            } catch (Exception e) {
                logger.warn("Could not delete index during reindex", e);
            }

            // Re-insert with contiguous IDs
            if (!allVibes.isEmpty()) {
                BulkRequest.Builder br = new BulkRequest.Builder();
                long newId = 1;
                for (Vibe v : allVibes) {
                    v.setId(String.valueOf(newId++));
                    br.operations(op -> op.index(idx -> idx.index(INDEX_NAME).id(v.getId()).document(v)));
                }
                BulkResponse response = openSearchClient.bulk(br.build());
                if (response.errors()) {
                    logger.error("Bulk reindex had errors");
                } else {
                    logger.info("Successfully reindexed vibes");
                }
            }
        } catch (Exception e) {
            logger.error("Error during vibe reindexing", e);
        }
    }

    public void bulkAddVibes(InputStream inputStream) throws IOException {
        long currentCount = 0;
        try {
            CountRequest countReq = new CountRequest.Builder().index(INDEX_NAME).build();
            CountResponse countRes = openSearchClient.count(countReq);
            currentCount = countRes.count();
        } catch (Exception e) {
            logger.warn("Could not get count for index {}", INDEX_NAME, e);
        }

        List<String> lines = new BufferedReader(new InputStreamReader(inputStream))
                .lines()
                .filter(l -> !l.trim().isEmpty())
                .collect(Collectors.toList());

        if (lines.isEmpty()) return;

        BulkRequest.Builder br = new BulkRequest.Builder();
        for (String line : lines) {
            currentCount++;
            Vibe v = new Vibe(String.valueOf(currentCount), line.trim());
            br.operations(op -> op.index(idx -> idx.index(INDEX_NAME).id(v.getId()).document(v)));
        }

        BulkResponse response = openSearchClient.bulk(br.build());
        if (response.errors()) {
            logger.error("Bulk add vibes had errors");
        } else {
            logger.info("Successfully added {} vibes via bulk", lines.size());
        }
    }

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
