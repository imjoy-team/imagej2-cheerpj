package io.imjoy.imagej2;

import net.imagej.ImageJ;

/**
 * Launches ImageJ.
 * 
 * @author Curtis Rueden
 */
public final class Main {

	private Main() {
		// prevent instantiation of utility class
	}

	public static void main(final String... args) {
		net.imagej.Main.main(args);
		/*
		final ImageJ ij = new ImageJ();
		ij.launch(args);
		*/
	}
}
