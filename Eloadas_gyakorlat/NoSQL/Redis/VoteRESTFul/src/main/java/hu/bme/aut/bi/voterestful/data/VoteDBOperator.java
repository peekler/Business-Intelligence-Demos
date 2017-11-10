package hu.bme.aut.bi.voterestful.data;

import hu.bme.aut.bi.voterestful.exception.RedisDBException;
import redis.clients.jedis.Jedis;

import java.util.*;

/**
 * Created by Peter on 31/08/2015.
 */
public class VoteDBOperator {

    private static final String KEY_DEMO_DEPARTMENT = "KEY_DEPARTMENT";
    private static final String KEY_NEW_USER_ID = "KEY_NEW_USER_ID";
    private static final String KEY_USERS = "KEY_USERS";
    private static final String KEY_A = "A";
    private static final String KEY_B = "B";
    private static final String KEY_C = "C";
    private static final String KEY_D = "D";

    private static final String FIELD_NAME = "FIELD_NAME";
    private static final String FIELD_VOTES = "FIELD_VOTES";

    private static VoteDBOperator instance = null;

    protected VoteDBOperator() {
        // Exists only to defeat instantiation.
    }
    public static VoteDBOperator getInstance() {
        if(instance == null) {
            instance = new VoteDBOperator();
        }
        return instance;
    }

    private Jedis jedis = null;

    public void connectDB() throws RedisDBException {
        jedis = new Jedis("localhost");
        jedis.connect();
        if (!jedis.isConnected()) {
            throw new RedisDBException();
        } else {
            initDB();
        }
    }

    public void initDB() {
        if (!jedis.exists(KEY_NEW_USER_ID)) {
            jedis.set(KEY_NEW_USER_ID, "100");
            clearVotes();
        }
    }

    public void clearVotes() {
        jedis.set(KEY_A, "0");
        jedis.set(KEY_B, "0");
        jedis.set(KEY_C, "0");
        jedis.set(KEY_D, "0");
    }

    public void disconnectDB() {
        if (jedis != null) {
            jedis.disconnect();
        }
        jedis = null;
    }

    public void clearDB(){
        jedis.flushDB();
        initDB();
    }

    public String getUserNameWithKey(String userName) {
        Set<String> keys = jedis.keys(userName + ":*");
        if (keys != null && keys.size()>0) {
            return (String) keys.toArray()[0];
        }
        else {
            return insertUser(userName);
        }
    }

    private String insertUser(String userName) {
        String newUserID = getNewUserID();
        String newUserName = userName+":"+newUserID;
        Map<String, String> newUserFields = new HashMap<>();
        newUserFields.put(FIELD_NAME, userName);
        newUserFields.put(FIELD_VOTES, "0");
        jedis.hmset(newUserName, newUserFields);

        jedis.sadd(KEY_USERS, newUserName);

        return newUserName;
    }

    public void setVote(String userNameWithKey, String vote) {
        jedis.incr(vote);

        jedis.hincrBy(userNameWithKey, FIELD_VOTES, 1);
    }

    public String getVote(String voteKey) {
        return jedis.get(voteKey);
    }

    public List<String> getUserStat() {
        Set<String> userKeys = jedis.smembers(KEY_USERS);
        List<String> result = new ArrayList<>();

        for (String userNameWithKey : userKeys) {
            String name = jedis.hget(userNameWithKey, FIELD_NAME);
            String vote = jedis.hget(userNameWithKey, FIELD_VOTES);
            result.add(name+": "+vote);
        }

        return result;
    }

    public void demoSetGetDel() {
        jedis.set(KEY_DEMO_DEPARTMENT, "AUT");
        String department = jedis.get(KEY_DEMO_DEPARTMENT);
        System.out.println("Stored department name is: "+ department);

        jedis.del(KEY_DEMO_DEPARTMENT);
        department = jedis.get(KEY_DEMO_DEPARTMENT);
        System.out.println("Stored department name is: " + department);
    }

    public String getNewUserID() {
        String newUserID = jedis.get(KEY_NEW_USER_ID);
        jedis.incr(KEY_NEW_USER_ID);
        return newUserID;
    }
}
