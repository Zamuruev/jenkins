package admin.jenkins_project;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class JenkinsProjectApplication {

    public static void main(String[] args) {
        SpringApplication.run(JenkinsProjectApplication.class, args);
        System.out.println("Я запустился, Ромашка!");
    }

}
