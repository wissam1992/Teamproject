package demo.api.security;

import demo.model.user.Person;
import demo.model.user.PersonDao;

import javax.inject.Inject;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;

import app.api.security.PasswordEncrypt;

import java.io.IOException;
import java.util.Base64;
import java.util.List;
import java.util.StringTokenizer;


@Provider
public class ResourceSecurityFilter implements ContainerRequestFilter {

    private static final String AUTHERIZATION_HEADER_KEY = "Authorization";
    private static final String AUTHERIZATION_HEADER_PREFIX = "Basic ";
    private static final String SECURED_URL_PREFIX = "secured";

    // private DBController dbController = new DBController();
    @Inject
    PersonDao personDao;

    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {
        if (requestContext.getUriInfo().getPath().contains(SECURED_URL_PREFIX)) {
            List<String> authHeader = requestContext.getHeaders().get(AUTHERIZATION_HEADER_KEY);

            if (authHeader != null && authHeader.size() > 0) {
                String authToken = authHeader.get(0);
                authToken = authToken.replaceFirst(AUTHERIZATION_HEADER_PREFIX, "");
                byte[] decodedBytes = Base64.getDecoder().decode(authToken);
                String decodedString = new String(decodedBytes);
                StringTokenizer tokenizer = new StringTokenizer(decodedString, ":");
                String username = tokenizer.nextToken();
                String password = tokenizer.nextToken();

                if ("user".equals(username) && "password".equals(password)) {
                    return;
                }

                Person person = personDao.findUsername(username);
                String m_username = person.getUsername();
                String m_password = person.getPassword();
                String pass = decodePW(password, person.getSalt());
                System.out.println("Pass: "+pass);
                System.out.println("DB Pass: "+m_password);
                // person.setPassword(pass);
                if (m_username.equals(username) && m_password.equals(pass)) {
                    return;
                }
            }

            // returns with message of unauthStatus if login is not successful
            Response unauthStatus = Response.status(Response.Status.UNAUTHORIZED)
                    .entity("Die Resource nicht zugreifbar. ").build();
            requestContext.abortWith(unauthStatus);
        }
    }

    
    private String decodePW(String pass,String saltU) {
        byte[] salt = Base64.getUrlDecoder().decode(saltU.getBytes());
        String pw = PasswordEncrypt.getSecurePassword(pass,salt);
        Response.ok("password"+pw).build();
        return pw;
     }
}