package hu.bme.aut.bi.redisvotefx;

import hu.bme.aut.bi.redisvotefx.data.exception.RedisDBException;
import hu.bme.aut.bi.redisvotefx.data.VoteDBOperator;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ListView;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;

import java.net.URL;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

public class Controller implements Initializable{

    @FXML
    private TextField tfUserName;
    @FXML
    private Button btnSubmit;
    @FXML
    private Button btnA;
    @FXML
    private Button btnB;
    @FXML
    private Button btnC;
    @FXML
    private Button btnD;
    @FXML
    private ListView listViewVotes;
    @FXML
    private TextArea textAreaOutput;

    private String currentUserNameWithKey;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        try {
            VoteDBOperator.getInstance().connectDB();
            printMessage("DB connected");
        } catch (RedisDBException e) {
            e.printStackTrace();
            printErrorMessage("DB not connected");
        }
    }

    public void btnSubmit(ActionEvent actionEvent) {
        if (!"".equals(tfUserName.getText())) {
            currentUserNameWithKey = VoteDBOperator.getInstance().getUserNameWithKey(tfUserName.getText());
            printMessage("Success, user is: " + currentUserNameWithKey);
            setVotingEnabledState(true);
        } else {
            printErrorMessage("username can not be empty");
        }
    }

    public void setVotingEnabledState(boolean enabled) {
        tfUserName.setDisable(enabled);
        btnSubmit.setDisable(enabled);
        btnA.setDisable(!enabled);
        btnB.setDisable(!enabled);
        btnC.setDisable(!enabled);
        btnD.setDisable(!enabled);
    }

    public void btnVoteA(ActionEvent actionEvent) {
        VoteDBOperator.getInstance().setVote(currentUserNameWithKey, "A");
        printMessage("Voted for A");
    }

    public void btnVoteB(ActionEvent actionEvent) {
        VoteDBOperator.getInstance().setVote(currentUserNameWithKey, "B");
        printMessage("Voted for B");
    }

    public void btnVoteC(ActionEvent actionEvent) {
        VoteDBOperator.getInstance().setVote(currentUserNameWithKey, "C");
        printMessage("Voted for C");
    }

    public void btnVoteD(ActionEvent actionEvent) {
        VoteDBOperator.getInstance().setVote(currentUserNameWithKey, "D");
        printMessage("Voted for D");
    }

    public void btnClearDB(ActionEvent actionEvent) {
        VoteDBOperator.getInstance().clearDB();
        setVotingEnabledState(false);
        printMessage("DB cleared");
    }

    public void btnNewVoting(ActionEvent actionEvent) {
        VoteDBOperator.getInstance().clearVotes();
        printMessage("Votes cleared");
    }

    public void btnGetVotes(ActionEvent actionEvent) {
        List<String> values = Arrays.asList(
                "A: " + VoteDBOperator.getInstance().getVote("A"),
                "B: " + VoteDBOperator.getInstance().getVote("B"),
                "C: " + VoteDBOperator.getInstance().getVote("C"),
                "D: " + VoteDBOperator.getInstance().getVote("D"));

        listViewVotes.setItems(FXCollections.observableList(values));
    }

    public void btnGetUserStats(ActionEvent actionEvent) {
        List<String> userStat = VoteDBOperator.getInstance().getUserStat();

        listViewVotes.setItems(FXCollections.observableList(userStat));
    }

    public void printMessage(String msg) {
        textAreaOutput.appendText(msg + "\n");
    }

    public void printErrorMessage(String msg) {
        textAreaOutput.appendText("ERROR: " + msg + "\n");
    }
}
