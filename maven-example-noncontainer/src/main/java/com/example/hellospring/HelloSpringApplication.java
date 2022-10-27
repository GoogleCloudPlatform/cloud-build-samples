/*
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.example.hellospring;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.core.env.Environment;

@SpringBootApplication
public class HelloSpringApplication implements CommandLineRunner {

	public static void main(final String[] args) {
		SpringApplication.run(HelloSpringApplication.class, args);
	}

	@Autowired
	private Environment env;
	
	public void run(String... args) {
		System.out.println(getBanner(env.getProperty("asciiColorMode")));
	}

	public final static String getBanner(String mode) {
		final String greeting = "Hello from Google Cloud!";

		final String logoBW = 
		"                                                                                \n"+
		"                                                                                \n"+
		"                              rrrrrrrrrrrrrrrrrrrr                              \n"+
		"                         rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr                        \n"+
		"                      rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr                     \n"+
		"                    rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrbb                   \n"+
		"                  rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrbbbbbb                 \n"+
		"                rrrrrrrrrrrrrrrrrrrrr       rrrrrrrrrrrrbbbbbbbbb               \n"+
		"              rrrrrrrrrrrrrrrrrrr             rrrrrrrbbbbbbbbbbbbb              \n"+
		"             rrrrrrrrrrrrrrrr                      bbbbbbbbbbbbbbbb             \n"+
		"            rrrYYYYYYYYYYYYYYYY                      bbbbbbbbbbbbbbb            \n"+
		"           YYYYYYYYYYYYYYYYYYYYYYY                     bbbbbbbbbbbbbb           \n"+
		"         YYYYYYYYYYYYYYYYYYYYYYYYYYY                    bbbbbbbbbbbbbb          \n"+
		"       YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY                  bbbbbbbbbbbbbbbb        \n"+
		"     YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY                  bbbbbbbbbbbbbbbbb      \n"+
		"    YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY                    bbbbbbbbbbbbbbbbbb     \n"+
		"   YYYYYYYYYYYYYYYYY        YYYYYYY                          bbbbbbbbbbbbbbb    \n"+
		"  YYYYYYYYYYYYYYY              YY                               bbbbbbbbbbbbb   \n"+
		"  YYYYYYYYYYYYYY                                                 bbbbbbbbbbbbb  \n"+
		"  YYYYYYYYYYYYY                                                  bbbbbbbbbbbbb  \n"+
		"  YYYYYYYYYYYYY                                                  bbbbbbbbbbbbb  \n"+
		"  YYYYYYYYYYYYYY                                                 bbbbbbbbbbbbb  \n"+
		"   YYYYYYYYYYYYYYY                                             bbbbbbbbbbbbbb   \n"+
		"    YYYYYYYYYYYYYYY                                          bbbbbbbbbbbbbbb    \n"+
		"     YYYYYYYYYYYYYGGGGGGGGGGGGGGGGGGGGGGGbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb     \n"+
		"      YYYYYYYYYYGGGGGGGGGGGGGGGGGGGGGGGGGbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb      \n"+
		"        YYYYYYGGGGGGGGGGGGGGGGGGGGGGGGGGGbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb        \n"+
		"          YYGGGGGGGGGGGGGGGGGGGGGGGGGGGGGbbbbbbbbbbbbbbbbbbbbbbbbbbbbb          \n"+
		"              GGGGGGGGGGGGGGGGGGGGGGGGGGGbbbbbbbbbbbbbbbbbbbbbbbbbb             \n"+
		"                 GGGGGGGGGGGGGGGGGGGGGGGGbbbbbbbbbbbbbbbbbbbbbbb                \n"+
		"                                                                                \n"+
		"                                                                                \n";

		

		// final String logo = "[0;5;37;47m  .  . .  .  . .  .  . . .  . .  .  . .  .  . . [0m\n[0;5;37;47m   .       .    .  .  .::. .   .   .      .     [0m\n[0;5;37;47m     .  .    . .  @[0;1;37;47m [0;1;33;47mX[0;5;35;41m [0;1;31;47mX[0;5;33;41m [0;1;31;47m8[0;5;33;41m.[0;33;47mX[0;1;31;47mX[0;1;37;47m [0;5;37;47m8. ..    . .    .  [0m\n[0;5;37;47m .       . .  X[0;1;37;47m.[0;1;31;47m@[0;5;37;41m8[0;5;33;41m  [0;5;37;41m88[0;5;33;41m [0;33;47m8[0;5;33;41m [0;1;31;47m@[0;5;33;41m [0;5;37;41m8[0;5;33;41m [0;5;1;33;41m@[0;5;37;41m8[0;1;31;47mX[0;1;37;47m [0;5;37;47m@.        .   .[0m\n[0;5;37;47m   .  .   ..[0;1;37;47m:[0;5;37;41m8[0;5;33;41m [0;5;37;41m8[0;5;33;41m [0;1;31;47m8[0;5;37;41m88[0;5;33;41m [0;1;33;47m8[0;5;35;41m [0;5;37;41m88[0;5;1;33;41m@[0;5;37;41m8888[0;5;33;41m [0;5;37;41m8[0;5;1;33;41mS[0;5;35;41m [0;1;31;47m@[0;1;37;47m:[0;5;37;47m..  .    .  [0m\n[0;5;37;47m  .    . .[0;1;37;47m:[0;5;33;41m [0;5;37;41m88@[0;5;1;33;41m8[0;5;37;41m8[0;5;33;41m [0;1;33;47m8[0;5;31;41m [0;1;31;47m@[0;5;35;41m [0;1;31;47mX[0;5;33;41m [0;1;31;47m8[0;5;37;41m8[0;5;33;41m [0;5;37;41m8[0;5;1;33;41m@[0;5;37;41m88888[0;35;47mS[0;1;30;47m8[0;5;37;46m8[0;1;37;47m [0;5;37;47m.    .    [0m\n[0;5;37;47m    .  . [0;1;37;47m [0;5;31;41m [0;1;31;47m8[0;5;33;41m [0;5;1;33;41m8[0;5;37;41m8888[0;5;33;41m [0;1;31;47m8[0;5;33;41m [0;5;37;41m888[0;5;1;33;41m8[0;5;37;41m88[0;5;33;41m [0;5;37;41m88[0;5;33;41m [0;5;1;33;41m8[0;5;37;41m8[0;1;37;47m [0;5;1;36;44m8[0;5;37;44m8[0;5;1;36;44m88[0;1;37;47m:[0;5;37;47m..     . [0m\n[0;5;37;47m  .   . [0;1;37;47m [0;5;31;41m [0;5;37;41m8[0;5;1;33;41m8[0;1;31;47m@[0;5;37;41m8[0;5;33;41m [0;5;37;41m8[0;5;33;41m [0;1;31;47m88[0;1;37;47m:[0;5;37;47m@t    ;X[0;1;37;47m [0;5;1;33;41m8[0;1;35;47m8[0;35;47m8[0;1;36;47m8[0;5;1;36;44m@[0;1;36;47mX[0;5;1;36;44m8[0;1;37;47m [0;5;1;34;46m8[0;5;1;36;44m8[0;5;37;47m8%.      [0m\n[0;5;37;47m    .  [0;1;37;47m [0;5;31;41m [0;5;1;31;43m8[0;5;37;41m8[0;5;1;33;41m8[0;5;1;31;43m8[0;5;37;43m8[0;5;1;33;41m8[0;5;37;43m@[0;5;1;33;41m8[0;5;37;47m8.. .   ...  S[0;1;37;47m [0;5;1;36;44m@[0;1;34;47mX[0;5;1;36;44m8[0;1;36;47mS[0;5;1;36;44m@[0;1;37;47m [0;5;1;36;44m88[0;5;37;47m8t. .  .[0m\n[0;5;37;47m  . . X[0;5;1;33;41m8[0;5;37;43mX[0;5;1;31;43mX[0;5;33;43m [0;5;37;43mS[0;5;1;31;43m8[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;31;43m@SS%[0;5;1;33;47m8[0;5;37;47m; .        8[0;5;1;36;44m8[0;1;36;47mX[0;5;1;36;44mX[0;1;34;47mS[0;5;1;36;44m8[0;1;37;47m [0;5;1;36;44m88[0;5;37;47m;..    [0m\n[0;5;37;47m    .X[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;33;41m8[0;5;33;43m [0;5;1;33;41m8[0;5;33;43m [0;5;1;33;41m8[0;5;33;43m [0;5;1;31;43m@[0;5;33;43m [0;5;1;31;43m@S[0;5;37;43m%[0;5;1;33;47m8[0;5;37;47mS. .     t[0;1;36;47mS[0;5;1;36;44mX[0;1;36;47mS[0;5;1;36;44m8[0;5;1;34;46m8[0;5;37;44m8[0;5;37;46m8[0;5;37;44m8[0;5;37;46m8[0;5;37;47m8S.   [0m\n[0;5;37;47m . %[0;5;33;43m  [0;5;1;33;41m8[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;33;41m8[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;31;43m8XX[0;5;33;43m [0;5;37;47mS .      X[0;5;1;36;44m8[0;5;37;44m8[0;5;37;47m8[0;5;1;36;44m8[0;5;37;46m8[0;5;1;35;44m8[0;5;37;46m8[0;5;1;36;44mX8[0;1;36;47m@[0;5;37;47m8t. [0m\n[0;5;37;47m. [0;1;33;47mS[0;5;33;43m [0;5;1;33;41m8[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;33;41m8[0;5;33;43m  [0;5;33;41m [0;5;33;43m  [0;5;33;41m [0;5;33;43m  [0;5;33;41m [0;5;33;43m  [0;5;1;31;43m8[0;5;33;43m [0;1;37;47m.[0;5;37;47mX .  .     [0;1;36;47mS[0;5;1;36;44m88[0;5;37;45m8[0;5;1;34;46m88[0;5;37;44m8[0;1;36;47mS[0;5;1;36;44m8[0;5;37;44m8[0;5;1;34;46m8[0;5;37;47m8% [0m\n[0;5;37;47m :[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;33;41m [0;5;33;43m  [0;5;33;41m.[0;5;33;43m .[0;1;33;47mX[0;5;37;47m8  S[0;1;33;47mS[0;5;33;43m [0;5;1;31;43m8[0;5;33;43m [0;5;1;31;43m8[0;5;37;47mt;.           .8[0;5;1;36;44m8[0;5;1;34;46m8[0;1;37;47m [0;5;1;36;44m88[0;5;37;47m8[0;5;1;36;44m8[0;5;37;44m8[0;5;1;34;46m8[0;5;37;47mS.[0m\n[0;5;37;47m [0;1;33;47m@[0;5;1;31;43m@[0;5;33;43m  .[0;5;33;41m.[0;5;33;43m..[0;1;33;47m8[0;5;37;47m8t.  . @[0;5;37;43m8[0;1;37;47m [0;5;37;47m%..  . .       tS%[0;5;37;46m8[0;5;1;36;44mX[0;5;37;47m8[0;5;1;36;44mX8[0;1;36;47mS[0;5;1;36;44m8[0;1;34;47mX[0;5;1;36;47m8[0;5;37;47m:[0m\n[0;5;37;47m [0;5;37;43mS[0;5;1;31;43m@8[0;5;33;43m ...[0;5;33;41m [0;5;37;47m.%:.   ..::.               .  [0;5;1;36;44m@8[0;1;37;47m [0;5;1;36;44m8[0;5;37;44m8[0;5;37;46m8[0;5;1;36;44m@[0;5;37;44m8[0;5;37;47m [0m\n[0;5;37;47m [0;5;37;43mS[0;5;33;43m [0;5;1;33;41m8[0;5;33;43m [0;5;33;41m.[0;5;33;43m.  [0;5;37;47m8:.      .   .  .  .         .[0;1;34;47mS[0;5;1;36;44m88[0;5;37;47m8[0;5;1;36;44m8[0;5;37;44m8[0;5;37;46m8[0;5;37;44m8[0;5;37;47m [0m\n[0;5;37;47m [0;5;37;43m8[0;5;1;31;43m8[0;5;33;43m [0;5;33;41m [0;5;33;43m .[0;5;33;41m.[0;5;33;43m [0;5;37;43m8[0;5;37;47m ... . . . .  .          .. 8[0;5;1;36;44m8[0;1;37;47m [0;5;1;36;44m88[0;1;37;47m [0;5;1;36;44m88[0;5;37;47m8t[0m\n[0;5;37;47m @[0;5;33;43m  ..[0;5;33;41m.[0;5;37;43m:[0;5;33;43m [0;5;1;31;43m8[0;5;37;43mX[0;5;37;47m8S::::::::.::.. . ..::;tX8[0;5;1;34;46m8[0;5;1;36;44m8[0;1;36;47mX[0;5;1;36;44m@[0;1;37;47m [0;5;1;36;44m88[0;5;37;47m8[0;5;1;36;44mX[0;5;37;47m8:[0m\n[0;5;37;47m.;[0;1;37;47m:[0;5;1;31;43m88[0;5;33;43m . [0;5;33;41m [0;5;33;43m [0;1;33;43mt[0;1;30;43m8[0;1;30;46m8[0;1;32;43m8[0;1;30;46m8[0;5;33;40m:[0;5;36;42mX[0;5;37;40m;[0;1;30;46m8[0;1;32;43m8[0;1;30;46m8[0;1;30;43m8[0;1;30;46m8[0;1;30;43m8[0;5;37;46m8[0;5;37;44m8[0;1;36;47m8[0;5;36;44m [0;1;36;47m8[0;5;37;44m8[0;5;37;46m@[0;5;36;44m [0;1;36;47m8[0;5;1;36;44m8[0;1;36;47m8[0;5;1;36;44m@8[0;1;37;47m [0;5;1;36;44m8[0;5;37;44m8[0;5;1;34;46m8[0;5;1;36;44m8[0;5;37;47m8[0;5;1;36;44mX8[0;5;37;47m8% [0m\n[0;5;37;47m ..8[0;5;33;43m [0;5;33;41m [0;5;33;43m. ;[0;5;36;40m [0;1;30;46m8[0;5;36;42mt[0;1;30;47m8[0;1;32;46m8[0;5;36;42mS[0;1;30;47m8[0;1;32;46m8[0;5;36;42mS[0;1;30;47m8[0;1;32;46m8[0;36;47m8[0;5;36;42m:[0;36;47m8[0;5;36;42mS[0;1;36;47m8[0;5;1;36;44m@[0;1;36;47m8[0;1;34;47m8[0;5;1;34;46m8[0;1;34;47m8[0;5;37;46m8[0;1;34;47m8[0;5;1;34;46m8[0;1;34;47mX[0;5;1;36;44m8[0;1;37;47m [0;5;1;36;44m88[0;1;37;47m [0;5;1;34;46m8[0;5;1;37;45m8[0;5;1;34;46m8[0;5;1;36;44m8[0;1;34;47mS[0;5;37;47m8X .[0m\n[0;5;37;47m   t@[0;5;33;43m .[0;5;33;40m;[0;5;36;40m [0;5;36;42m%[0;1;30;47m8[0;1;32;46m8[0;1;30;46m8[0;33;47m8[0;1;32;46m88[0;1;30;47m8[0;1;32;46m8[0;5;36;40m.[0;5;36;42m:[0;5;37;40m%[0;1;32;46m8[0;1;30;46m88[0;1;36;47m8[0;5;37;44m8[0;5;1;36;44m8[0;1;36;47m@[0;5;1;36;44m8[0;1;36;47m@[0;5;1;36;44mS[0;1;36;47m@[0;5;37;44m8[0;5;37;46m8[0;5;37;44m8[0;5;1;34;46m8[0;1;37;47m [0;5;1;36;44m88[0;1;36;47mS[0;5;1;36;44m8[0;5;37;44m8[0;5;1;37;46m8[0;5;37;47m88.  [0m\n[0;5;37;47m  . : @[0;1;37;47m [0;36;47m8[0;1;32;46m8[0;1;30;46m8[0;5;33;42mt[0;37;46m8[0;5;36;42mS[0;5;37;40mt[0;5;36;42mS[0;5;36;40m.[0;5;36;42m;[0;36;47m8[0;1;32;46m8[0;37;46m8[0;5;33;42mS[0;36;47m8[0;5;36;42m@[0;1;34;47m8[0;5;37;46m8[0;5;37;44m8[0;5;1;36;44m8[0;1;34;47mS[0;5;1;36;44m8[0;1;34;47mS[0;5;1;36;44m8[0;5;1;34;46m8[0;5;37;44m8[0;5;37;46m8[0;5;1;35;44m@[0;5;1;34;46m@[0;1;37;47m [0;5;1;36;44m8[0;1;37;47m [0;5;1;36;47m8[0;5;37;47m8:t..  [0m\n[0;5;37;47m    :..   [0;1;37;47mX [0;1;32;47m8[0;36;47m8[0;5;37;42m8[0;1;30;47m8[0;36;47m88[0;5;33;42mt[0;1;30;47m8[0;5;37;42m8[0;36;47m8[0;5;33;42mX[0;1;30;47m;[0;5;37;46m@[0;5;37;44m8[0;5;37;46m8[0;1;37;47m [0;5;1;34;46m8[0;1;37;47m [0;5;1;34;46m8[0;5;37;47m8[0;5;37;44m8[0;5;1;37;46m8[0;5;37;44m8[0;5;1;37;46m8[0;5;37;47m888t...   . [0m\n[0;5;37;47m  . . .   :;:. ;t       ;      .   .8X. .       [0m\n[0;5;37;47m    .        ...        .                  . .  [0m\n[0;5;37;47m  .             .                     .  .     .[0m\n\n";
		return greeting + "\n" + colorizeAscii(logoBW,mode);
	}


	public final static String colorizeAscii(final String Ascii, final String mode) {

		StringBuilder returnString = new StringBuilder();

		final HashMap<Character, String> colorGlyphs = new HashMap<>();

		if(mode.equalsIgnoreCase("emoji")) {
			colorGlyphs.put('r', "🔴");
			colorGlyphs.put('G', "💚️");
			colorGlyphs.put('Y', "💛️");
			colorGlyphs.put('b', "💙️");
			colorGlyphs.put(' ', "⚪️️");
		} else {
			colorGlyphs.put('r', "\u001b[31m█\u001b[0m");
			colorGlyphs.put('G', "\u001b[32m█\u001b[0m");
			colorGlyphs.put('Y', "\u001b[33m█\u001b[0m");
			colorGlyphs.put('b', "\u001b[34m█\u001b[0m");
			colorGlyphs.put(' ', " ");
		}

		for (Character c : Ascii.toCharArray()) {
			returnString.append(colorGlyphs.getOrDefault(c, c.toString()));
		}

		return returnString.toString();
	}
}
