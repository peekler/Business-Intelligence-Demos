package hu.bme.aut.bi.cassandrademo;

import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.ResultSet;
import com.datastax.driver.core.Row;
import com.datastax.driver.core.Session;

public class Main {

    private Cluster cluster;
    private Session session;

    public static void main(String[] args) {
        System.out.println("Started");
        new Main();
        System.out.println("Stopped");
    }

    public Main() {
        // For showing the features on the course
        connect();
        insertDummyItem();
        printDummyItems();
        disconnect();
    }

    private void connect() {
        cluster = Cluster.builder().addContactPoint("127.0.0.1").build();
        session = cluster.connect("bikeyspace");
    }

    private void insertDummyItem() {
        session.execute("insert into items (item_id, name, price) values (4, 'javabread', '220')");
    }

    private void printDummyItems() {
        ResultSet results = session.execute("select * from items");
        for (Row row : results) {
            System.out.format("%s %s\n", row.getString("name"), row.getString("price"));
        }
    }

    private void disconnect() {
        if (cluster != null) {
            cluster.close();
        }
    }
}
