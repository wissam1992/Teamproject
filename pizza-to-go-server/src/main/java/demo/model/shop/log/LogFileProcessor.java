package demo.model.shop.log;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.nio.channels.OverlappingFileLockException;
import java.nio.file.Files;
import java.nio.file.attribute.PosixFilePermission;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import demo.model.ref.DatabaseEntity;
import demo.model.ref.Logable;
import demo.model.ref.Status;

public class LogFileProcessor {

    private int orderId;

    private Status status;

    private static LogFileProcessor instance = null;
    RandomAccessFile delivery;
    RandomAccessFile provision;
    FileChannel deliveryChannel;
    FileChannel provisionChannel;
    FileLock lock = null;

    //Thread Pool für Dateibehandlung
    ExecutorService executorService = new ThreadPoolExecutor(1, 1, 0L, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<Runnable>());

    //beim ersten Zugriff auf diese Klasse wird ein Objekt 
    //dieser Klasse erzeugt . für die zu speichernden Daten werden 
    //zwei verschiedene Protokolldateien angelegt  
    private LogFileProcessor() {
        try {
            delivery = new RandomAccessFile("/logs/delivery.log", "rw");
            provision = new RandomAccessFile("/logs/provision.log", "rw");
        } catch (FileNotFoundException e) {
            System.out.println(e.getMessage());
        }
        deliveryChannel = delivery.getChannel();
        provisionChannel = provision.getChannel();
    }

    public static synchronized LogFileProcessor getInstance() {
        if (instance == null) {
            instance = new LogFileProcessor();
        }

        return instance;
    }
    //Eine Logable Typ Entity wird als Parameter eingegeben , welche weiter zu processFile gegeben.
    public Runnable createFileLog(Logable entity) throws IOException {
        return () -> {
            String name = entity.getClass().getName().toUpperCase();
            System.out.println(name + ": " + entity);
            try {
                processFile(entity, getFileChannel(entity, name),getFile(entity, name));
            } catch (IOException e) {
                System.out.println(e.getMessage());
            }
        };
    }

    //Runnable Process für Dateibearbeiten werden in executorservice hinzugefügt
    public void executeService(Runnable runnable){
        this.executorService.submit(runnable);
    }

    //Mit Logable entity und Klassenname bekommen wir richtige FileChannel zurück
    private FileChannel getFileChannel(Logable entity, String name) throws IOException {
        switch (name) {
            case "DEMO.MODEL.SHOP.ENTITIES.DELIVERY":
                return deliveryChannel;
            case "DEMO.MODEL.BESCHAFFUNGSWESEN.NACHBESTELLUNG":
                return provisionChannel;
        }
        return null;
    }
    private RandomAccessFile getFile(Logable entity, String name) throws IOException {
        switch (name) {
            case "DEMO.MODEL.SHOP.ENTITIES.DELIVERY":
                return delivery;
            case "DEMO.MODEL.BESCHAFFUNGSWESEN.NACHBESTELLUNG":
                return provision;
        }
        return null;
    }

    public String getLogData(String name) throws IOException {
        switch (name) {
            case "DEMO.MODEL.SHOP.ENTITIES.DELIVERY":
                return getFileContents(provision);
            case "DEMO.MODEL.BESCHAFFUNGSWESEN.NACHBESTELLUNG":
                return getFileContents(delivery);
        }
        return "No Log File";
    }


    private String getFileContents(RandomAccessFile file) throws IOException {
        StringBuffer buffer1 = new StringBuffer();
        //Reading each line using the readLine() method
        while(file.getFilePointer() < file.length()) {
           buffer1.append(file.readLine()+System.lineSeparator());
        }
        String text1 = buffer1.toString();
        return text1;
    }

    public void processFile(Logable entity, FileChannel channel, RandomAccessFile file) throws IOException {
        try {
            lock = channel.tryLock();
        } catch (OverlappingFileLockException e) {
            file.close();
            channel.close();
            System.out.println(e.getMessage());
        }
        Date date = new Date();
        //Aktuelle Zeit und Entity Log Data werden in File Log gespeichert.
        file.writeChars(date + " " + entity.toString() + "\n");

        lock.release();
    }

    public void closeFile() throws IOException {
        delivery.close();
        deliveryChannel.close();
        provision.close();
        provisionChannel.close();
    }

    //file permission 
    public void setPermission(File file) throws IOException {
        Set<PosixFilePermission> perms = new HashSet<>();
        perms.add(PosixFilePermission.OWNER_READ);
        perms.add(PosixFilePermission.OWNER_WRITE);
        perms.add(PosixFilePermission.OWNER_EXECUTE);

        perms.add(PosixFilePermission.OTHERS_READ);
        perms.add(PosixFilePermission.OTHERS_WRITE);
        perms.add(PosixFilePermission.OTHERS_EXECUTE);

        perms.add(PosixFilePermission.GROUP_READ);
        perms.add(PosixFilePermission.GROUP_WRITE);
        perms.add(PosixFilePermission.GROUP_EXECUTE);

        Files.setPosixFilePermissions(file.toPath(), perms);
    }

    public int getOrderId() {
        return this.orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Status getStatus() {
        return this.status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public RandomAccessFile getStream() {
        return this.delivery;
    }

    public FileChannel getChannel() {
        return this.deliveryChannel;
    }

    public FileLock getLock() {
        return this.lock;
    }

}
