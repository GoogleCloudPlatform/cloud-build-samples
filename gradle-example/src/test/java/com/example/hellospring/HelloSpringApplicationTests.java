package com.example.hellospring;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class HelloSpringApplicationTests {

	@Test
	void contextLoads() {
	}

	@Test
	void greetingShown() {
		String bannerString=HelloSpringApplication.getBanner("ANSI");
		assertTrue(bannerString.contains("Hello from Google Cloud!"));
		}

	@Test
	void emojiGreetingShown() {
		String bannerString=HelloSpringApplication.getBanner("emoji");
		assertTrue(bannerString.contains("Hello from Google Cloud!"));
		}		
}