package demo.model.user;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "Person")
//uniqueConstraints={@UniqueConstraint(columnNames = {"username"})}
@NamedQuery(name = "Person.findAll", query = "SELECT p FROM Person p")
@NamedQuery(name = "Person.findPerson", query = "SELECT p FROM Person p WHERE "
    + "p.username = :username AND p.email = :email")
@NamedQuery(name = "Person.findPersonUsername", query = "SELECT p FROM Person p WHERE "
    + "p.username = :username")
public class Person {

    @GeneratedValue(strategy = GenerationType.AUTO)
    @Id
    @Column(name = "personId")
    private int id;

    @Column(name = "address")
    private String address;
    
    @Column(name = "firstName")
    private String firstname;

    @Column(name = "lastName")
    private String lastname;

    @Column(name = "username")
    private String username;

    @Column(name = "password")
    private String password;

    @Column(name = "email")
    private String email;

    @Column(name = "salt")
    private String salt;

    public Person() {
    }


    public Person(String firstname, String lastname, String username, String password, String email, String address) {
        this.address = address;
        this.firstname = firstname;
        this.lastname = lastname;
        this.username = username;
        this.password = password;
        this.email = email;
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSalt() {
        return this.salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    public String getAddress() {
        return this.address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getFirstname() {
        return this.firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return this.lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getUsername() {
        return this.username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Person id(int id) {
        this.id = id;
        return this;
    }

    public Person address(String address) {
        this.address = address;
        return this;
    }

    public Person firstname(String firstname) {
        this.firstname = firstname;
        return this;
    }

    public Person lastname(String lastname) {
        this.lastname = lastname;
        return this;
    }

    public Person username(String username) {
        this.username = username;
        return this;
    }

    public Person password(String password) {
        this.password = password;
        return this;
    }

    public Person email(String email) {
        this.email = email;
        return this;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof Person)) {
            return false;
        }
        Person person = (Person) o;
        return id == person.id && Objects.equals(address, person.address) && Objects.equals(firstname, person.firstname) && Objects.equals(lastname, person.lastname) && Objects.equals(username, person.username) && Objects.equals(password, person.password) && Objects.equals(email, person.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, address, firstname, lastname, username, password, email);
    }

    @Override
    public String toString() {
        return "{" +
            " id='" + getId() + "'" +
            ", address='" + getAddress() + "'" +
            ", firstname='" + getFirstname() + "'" +
            ", lastname='" + getLastname() + "'" +
            ", username='" + getUsername() + "'" +
            ", email='" + getEmail() + "'" +
            "}";
    }
    

}
