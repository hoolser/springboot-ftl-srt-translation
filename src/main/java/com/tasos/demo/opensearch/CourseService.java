package com.tasos.demo.opensearch;

import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.opensearch.core.DeleteRequest;
import org.opensearch.client.opensearch.core.DeleteResponse;
import org.opensearch.client.opensearch.core.IndexRequest;
import org.opensearch.client.opensearch.core.IndexResponse;
import org.opensearch.client.opensearch.core.SearchRequest;
import org.opensearch.client.opensearch.core.SearchResponse;
import org.opensearch.client.opensearch._types.query_dsl.Query;
import org.opensearch.client.opensearch._types.query_dsl.BoolQuery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@ConditionalOnProperty(name = "opensearch.enabled", havingValue = "true")
public class CourseService {

    private static final Logger logger = LoggerFactory.getLogger(CourseService.class);
    private static final String INDEX_NAME = "courses";

    @Autowired
    private OpenSearchClient openSearchClient;

    public void createCourse(Course course) throws IOException {
        if (course.getId() == null) {
            course.setId(UUID.randomUUID().toString());
        }
        IndexRequest<Course> request = new IndexRequest.Builder<Course>()
                .index(INDEX_NAME)
                .id(course.getId())
                .document(course)
                .build();
        IndexResponse response = openSearchClient.index(request);
        logger.info("Successfully created course with id: {}", response.id());
    }

    public List<Course> getAllCourses() throws IOException {
        SearchRequest searchRequest = new SearchRequest.Builder()
                .index(INDEX_NAME)
                .build();

        SearchResponse<Course> response = openSearchClient.search(searchRequest, Course.class);
        return response.hits().hits().stream()
                .map(hit -> hit.source())
                .collect(Collectors.toList());
    }

    public List<Course> searchCourses(String title, String description) throws IOException {
        BoolQuery.Builder boolQueryBuilder = new BoolQuery.Builder();
        boolean hasConditions = false;

        if (title != null && !title.trim().isEmpty()) {
            boolQueryBuilder.must(m -> m.wildcard(w -> w.field("title").value("*" + title.toLowerCase() + "*")));
            hasConditions = true;
        }
        if (description != null && !description.trim().isEmpty()) {
            boolQueryBuilder.must(m -> m.wildcard(w -> w.field("description").value("*" + description.toLowerCase() + "*")));
            hasConditions = true;
        }

        Query query;
        if (!hasConditions) {
            query = new Query.Builder().matchAll(ma -> ma).build();
        } else {
            query = new Query.Builder().bool(boolQueryBuilder.build()).build();
        }

        SearchRequest searchRequest = new SearchRequest.Builder()
                .index(INDEX_NAME)
                .query(query)
                .build();

        SearchResponse<Course> response = openSearchClient.search(searchRequest, Course.class);
        return response.hits().hits().stream()
                .map(hit -> hit.source())
                .collect(Collectors.toList());
    }

    public void deleteCourse(String id) throws IOException {
        DeleteRequest deleteRequest = new DeleteRequest.Builder()
                .index(INDEX_NAME)
                .id(id)
                .build();
        DeleteResponse response = openSearchClient.delete(deleteRequest);
        logger.info("Deleted course with id: {}, Result: {}", id, response.result());
    }
}
