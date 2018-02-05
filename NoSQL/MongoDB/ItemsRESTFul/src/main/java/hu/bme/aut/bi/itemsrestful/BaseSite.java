package hu.bme.aut.bi.itemsrestful;

import javax.ws.rs.*;

import com.mongodb.Block;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;


@Path("/")
public class BaseSite {
    @GET
    @Path("/items")
    @Produces("text/plain")
    public String getItems() {
        final StringBuilder sb = new StringBuilder();

        MongoClient mongoClient = new MongoClient();
        MongoDatabase db = mongoClient.getDatabase("test");
        FindIterable<Document> iterable = db.getCollection("items").find();
        iterable.forEach(new Block<Document>() {
            @Override
            public void apply(final Document document) {
                sb.append(document.getString("name")+"\n");
            }
        });

        return sb.toString();
    }
}