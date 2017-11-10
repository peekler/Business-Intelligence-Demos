package hu.bme.aut.bi.voterestful;

import hu.bme.aut.bi.voterestful.data.VoteDBOperator;
import hu.bme.aut.bi.voterestful.exception.RedisDBException;

import javax.ws.rs.*;


@Path("/")
public class BaseSite {

    private String currentUserNameWithKey;

    public BaseSite() {
        try {
            VoteDBOperator.getInstance().connectDB();
            currentUserNameWithKey = VoteDBOperator.getInstance().getUserNameWithKey("web-anonim");
        } catch (RedisDBException e) {
            e.printStackTrace();
        }
    }

    @GET
    @Path("/test")
    @Produces("text/plain")
    public String demo() {
        return "Demo";
    }

    @POST
    @Path("/vote")
    @Produces("text/plain")
    public String vote(String voteValue) {
        VoteDBOperator.getInstance().setVote(currentUserNameWithKey, voteValue);

        return voteValue + " was voted by "+currentUserNameWithKey;
    }
}