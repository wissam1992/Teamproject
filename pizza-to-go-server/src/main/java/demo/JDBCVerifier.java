package demo;

import javax.annotation.Resource;
import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.context.Initialized;
import javax.enterprise.event.Observes;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

@WebServlet(urlPatterns = "/db")
@ApplicationScoped
public class JDBCVerifier extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Resource(lookup = "jdbc/mySQL")
    private DataSource dataSource;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().append("JDBC Verifier!\n");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    public void init(@Observes @Initialized(ApplicationScoped.class) Object init) throws SQLException {
        System.out.println("Verifying Connection!");

        DatabaseMetaData metaData = dataSource.getConnection().getMetaData();

        System.out.println(metaData.getDatabaseProductName());
        System.out.println("Version: "+metaData.getDatabaseMajorVersion());
    }
}