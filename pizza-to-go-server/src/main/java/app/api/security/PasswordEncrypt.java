package app.api.security;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.SecureRandom;

public class PasswordEncrypt {

    public static byte[] getSalt() throws NoSuchAlgorithmException, NoSuchProviderException {
        SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
        // array for salt
        byte[] salt = new byte[16];
        // a random salt
        sr.nextBytes(salt);
        // return salt
        return salt;
    }

    public static String getSecurePassword(String passwordToHash, byte[] salt) {
        String generatedPassword = null;
        try {
            // Create MessageDigest instance for MD5 , SHA-512
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            // Add password bytes to digest
            md.update(salt);
            // Get the hash's bytes
            byte[] bytes = md.digest(passwordToHash.getBytes());
            // This bytes[] has bytes in decimal format;
            // Convert it to hexadecimal format
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < bytes.length; i++) {
                sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
            }
            // Get complete hashed password in hex format
            generatedPassword = sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return generatedPassword;
    }
}