---
layout: page
title: "Java I/O"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Basics

* I/O in Java is divided into two types: 
   * **byte- and number-oriented I/O**, which is handled by input and output streams; and 
   * **character and text I/O**, which is handled by readers and writers.
* Java Communications API (`javax.comm`),which provides the ability to do low-level I/O through a computer's serial and parallel ports.
* Streams classes read and write bytes. `Reader` classes read characters and `Writer` classes write characters.
* Numeric data
  * `int` - Fundamental integer data type in Java is 'int', a 4-byte, big endian, two's complement integers
  * `long` - 8-byte, big endian, two's complement integers
  * `short` - 2-byte, big endian, two's complement integers (rarely used)
  * `byte` - 1-byte, big endian, two's complement integer from -128 to 127 (heavily used in I/O)
* There are no short or byte literals in Java. 

```java
byte b = 42; //though 42 is an int, compiler specially converts them to narrower type 
short s = 24000; //same as above
int i = 42; // not allowed
short s = i; //assigning from int variables to shorts or bytes is not allowed without explicit cast.
byte b = i; // not allowed
byte b = 1 + 2; // not allowed
```

# Stream Classes

* A stream is an ordered sequence of bytes of undetermined length.
* The two main classes are `java.io.InputStream` and `java.io.OutputStream`. 
* The `java.util.zip` package contains four input stream classes that read data in a compressed format and return it in uncompressed format and four output stream classes that read data in uncompressed format and write in compressed format.
* The `java.util.jar` package includes two stream classes for reading files from JAR archives.
* The `java.security` package includes a couple of stream classes used for calculating message digests.
* The Java Cryptography Extension (JCE) adds two classes for encryption and decryption.

## Input Stream 

`public abstract int read() throws IOException`

Though `read()` returns stream of bytes, it is declared as `int`. This `int` is not a Java byte with a value between -128 and 127 but a more general unsigned byte with a value between 0 and 255. Hence, `-1` can easily be distinguished from valid data values read from the stream.

# OutputStream 

`public abstract void write(int byte) throws IOException`

This int is intended to be an unsigned byte value between and 255. However, there's nothing to stop a careless programmer from passing in an int value outside that range. In this case, the eight low-order bits are written and the top 24 high-order bits are ignored. 

# Character classes

* Character Data type - In Java, a `char` is a two-byte, unsigned integer, the only unsigned type in Java. 
* The `java.io.Reader` and `java.io.Writer` classes are abstract superclasses for classes that read and write character-based data. The subclasses are notable for handling the conversion between different character sets.
* For the most part, these classes have methods that are extremely similar to the equivalent stream classes. Often the only difference is that a byte in the signature of a stream method is replaced by a char in the signature of the matching reader or writer method.

# Streams

## Byte Streams

Byte streams for reading and writing are called input streams and output streams, respectively (represented by the abstract classes `InputStream` and `OutputStream`). 

Programs use byte streams to perform input and output of 8-bit bytes. It should only be used for the most primitive I/O.

```java
private void byteStreams(){
   byte[] magicalJavaClassSignature = new byte[]{(byte)0xCA, (byte)0xFE, (byte)0xBA, (byte)0xBE, };
   String filename = "C:/temp/bytestream.data";

   try(FileOutputStream fos = new FileOutputStream(filename)){
      fos.write(magicalJavaClassSignature);
   }catch (Exception e){
      e.printStackTrace();
   }

   try(FileInputStream fis = new FileInputStream(filename)){
      byte[] bytes = new byte[4];
      fis.read(bytes);
      if(Arrays.equals(magicalJavaClassSignature, bytes)){
         System.out.println("Matching...");
      } else {
         System.out.println("Not matching...");
      }
   }catch (Exception e){
      e.printStackTrace();
   }
}
```

## Data Streams

* Data streams support binary I/O of primitive data type values (`boolean, char, byte, short, int, long, float, and double) as well as String values. 
* All data streams implement either the DataInput interface or the DataOutput interface. 
* Also notice that each specialized write in DataStreams is exactly matched by the corresponding specialized read. It is up to the programmer to make sure that output types and input types are matched in this way: The input stream consists of simple binary data, with nothing to indicate the type of individual values, or where they begin in the stream.

```java
private void dataStreams() {
   String filename = "C:/temp/datastream.data";
   try (DataOutputStream dos = new DataOutputStream(new FileOutputStream(filename))) {
      for (int i = 0; i < 10; i++) {
         dos.writeByte(i);
         dos.writeShort(i);
         dos.writeInt(i);
         dos.writeLong(i);
         dos.writeFloat(i);
         dos.writeDouble(i);
      }
   } catch (Exception e) {
      e.printStackTrace();
   }

   try (DataInputStream dis = new DataInputStream(new FileInputStream(filename))) {
      for (int i = 0; i < 10; i++) {
         System.out.printf("%d %d %d %d %g %g %n",
            dis.readByte(),
            dis.readShort(),
            dis.readInt(),
            dis.readLong(),
            dis.readFloat(),
            dis.readDouble());
      }
   } catch (Exception e) {
      e.printStackTrace();
   }
}
```

## Object Streams

The object stream classes are `ObjectInputStream` and `ObjectOutputStream`. These classes implement `ObjectInput` and `ObjectOutput`, which are subinterfaces of `DataInput` and `DataOutput`. That means that all the primitive data I/O methods covered in Data Streams are also implemented in object streams. So an object stream can contain a mixture of primitive and object values.

```java
	private void objectStreams() {
   String filename = "C:/temp/objectstream.data";
   try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(filename))) {
      oos.writeObject(Arrays.asList("hello", "how", "are", "you")); //write object to stream
   } catch (Exception e) {
      e.printStackTrace();
   }


   try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filename))) {
      Object obj = ois.readObject(); //read object from stream
      if (obj != null && obj instanceof List) {
         System.out.println(obj);
      } else {
         System.out.println("Object is null or not a Map");
      }
   } catch (Exception e) {
      e.printStackTrace();
   }
}
```

## Character Streams

* are often "wrappers" for byte streams. Byte stream is used to perform the physical I/O, while the character stream handles translation between characters and bytes.
* represented by the abstract classes `Reader` and `Writer`
* The Java platform stores character values using Unicode conventions. Character stream I/O automatically translates this internal format to and from the local character set. In Western locales, the local character set is usually an 8-bit superset of ASCII.
* For most applications, I/O with character streams is no more complicated than I/O with byte streams. Input and output done with stream classes automatically translates to and from the local character set. A program that uses character streams in place of byte streams automatically adapts to the local character set and is ready for internationalization — all without extra effort by the programmer.
* If internationalization isn't a priority, you can simply use the character stream classes without paying much attention to character set issues. Later, if internationalization becomes a priority, your program can be adapted without extensive recoding.
* There are two general-purpose byte-to-character "bridge" streams: `InputStreamReader` and `OutputStreamWriter`. Use them to create character streams when there are no prepackaged character stream classes that meet your needs.

```java
private void characterStreams(){
   String filename = "C:/temp/charactstream.data";
   try (FileWriter fw = new FileWriter(filename)) {
      fw.write("What do you want to do today?");
      fw.append("\nhello").append("world");
      fw.flush();
   } catch (Exception e) {
      e.printStackTrace();
   }


   try (FileReader fr = new FileReader(filename)) {
      char[] chars = new char[100];
      fr.read(chars);
      System.out.println("Char stream read: " + new String(chars));
   } catch (Exception e) {
      e.printStackTrace();
   }
}
```

## Buffered Streams

* This means each read or write request is handled directly by the underlying OS. This can make a program much less efficient, since each such request often triggers disk access, network activity, or some other operation that is relatively expensive.
* To reduce this kind of overhead, the Java platform implements buffered I/O streams. Buffered input streams read data from a memory area known as a buffer; the native input API is called only when the buffer is empty. Similarly, buffered output streams write data to a buffer, and the native output API is called only when the buffer is full.
* Invoking readLine returns a line of text with the line. CopyLines outputs each line using println, which appends the line terminator for the current operating system. This might not be the same line terminator that was used in the input file.
* There are four buffered stream classes used to wrap unbuffered streams: `BufferedInputStream` and `BufferedOutputStream` create buffered byte streams, while `BufferedReader` and `BufferedWriter` create buffered character streams.

```java Buffered Byte Streams
private void bufferedByteStreams(){
   String filename = "C:/temp/bufferedbytestream.data";
   try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(filename))) {
      bos.write("hello world \n What do you want to do today?".getBytes());
   } catch (Exception e) {
      e.printStackTrace();
   }

   try (BufferedInputStream bis = new BufferedInputStream(new    FileInputStream(filename))) {
      byte[] bytes = new byte[100];
      bis.read(bytes);
      System.out.println(new String(bytes));
   } catch (Exception e) {
      e.printStackTrace();
   }
}
```

```java Buffered Character Streams
private void bufferedCharacterStreams(){
   String filename = "C:/temp/bufferedcharstream.data";
   try (BufferedWriter bw = new BufferedWriter(new FileWriter(filename))) {
      bw.write("hello world");
      bw.newLine();
      bw.write("What do you want to do today?");
   } catch (Exception e) {
      e.printStackTrace();
   }

   try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
      String input = null;
      while( (input = br.readLine()) !=null){
         System.out.println(input);
      }
   } catch (Exception e) {
      e.printStackTrace();
   }
}
```

# Scanner

Objects of type `Scanner` are useful for breaking down formatted input into tokens and translating individual tokens according to their data type.

```java
private void scanner() {
   Scanner scanner = new Scanner("Hello/1/2.3/");
   scanner = scanner.useDelimiter(Pattern.compile("/"));
   System.out.println(scanner.next());
   System.out.println(scanner.nextInt());
   System.out.println(scanner.nextFloat());
}
```

# Serialization

## Customize default serialization protocol 

Implement following methods to custom read/write objects. Notice that both methods are (and must be) declared `private`, proving that neither method is inherited and overridden or overloaded. The trick here is that the virtual machine will automatically check to see if either method is declared during the corresponding method call. If your super class implements `Serializable` and if you don't want your class to be serialized, then implement these 2 methods to throw `NotSerializableException`. 

```java
private void writeObject(ObjectOutputStream out) throws IOException; 
private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException; 
```

## Customize your own protocol 

If you dont want to use the default java serialization technique, you can define your own technique by implementing `Externalizable` instead of `Serializable`. Following 2 methods needs to be implemented by your class which would contain the algorithm to persist your object. 

```java
public void writeExternal(ObjectOutput out) throws IOException; 
public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException; 
```

## Caching objects in the stream 

By default, an `ObjectOutputStream` will maintain a reference to an object written to it. That means that if the state of the written object is written and then written again, the new state will not be saved! 

```java
ObjectOutputStream out = new ObjectOutputStream(...); 
MyObject obj = new MyObject(); // must be Serializable 
obj.setState(100); 
out.writeObject(obj); // <--------saves object with state = 100 
obj.setState(200); 
out.writeObject(obj); // <--------does not save new object state 
```

To avoid the situation, do either one of the below : 
* 1. Close and open the stream again, or 
* 2. call stream.reset() 

Changes to a class that can hurt de-serialization : 
* 1. deleting an instance variable 
* 2. change

# Java NIO

## Why NIO?

* The `File` class lacked the significant functionality required to implement even commonly used functionality. For instance, it lacked a `copy()` method to copy a file/directory.
* The `File` class defined many methods that returned a `Boolean` value. Thus, in case of an error, false was returned, rather than throwing an exception, so the developer had no way of knowing why that call failed.
* The `File` class did not provide good support for handling symbolic links.
* The `File` class handled directories and paths in an inefficient way (it did not scale well).
* The `File` class provided access to a very limited set of file attributes, which was insufficient in many situations.

## Buffers, Channels, Selectors

...

## File Watcher Service

```java File Watcher Service
 private void fileWatcherService() throws Exception{
   Path path = Paths.get("C:/temp");
   WatchService watchService = path.getFileSystem().newWatchService();
   path.register(watchService, StandardWatchEventKinds.ENTRY_MODIFY); //only event can be registered per watch service

   for(;;){
      final WatchKey watchKey = watchService.take();
      for (WatchEvent<?> watchEvent : watchKey.pollEvents()) {
         final Path context = (Path) watchEvent.context();
         System.out.println("Event kind: " + watchEvent.kind().name() + " - " + context.getFileName());
      }
      watchKey.reset(); //resetting the key is important to receive subsequent notifications
    }
}
```

# Character Sets

[The Absolute Minimum Every Software Developer Absolutely, Positively Must Know About Unicode and Character Sets (No Excuses!) by Joel Spolsky](http://www.joelonsoftware.com/articles/Unicode.html)

## ASCII

{% img right /technology/ascii-table.gif %}
* the American Standard Code for Information Interchange, is a 7-bit character set. Thus it defines 27 or 128 different characters whose numeric values range from to 127.
* All Java programs can be expressed in pure ASCII. Non-ASCII Unicode characters are encoded as Unicode escapes; that is, written as a backslash ( \), followed by a u, followed by four hexadecimal digits; for example, \u00A9.


## ISO Latin-1

ISO Latin-1 is an eight-bit character set that's a strict super-set of ASCII. It defines 28 or 256 different characters whose numeric values range from to 255. The first 128 characters—that is, those numbers with the high-order bit equal to zero—correspond exactly to the ASCII character set. Thus 65 is ASCII A and ISO Latin-1 A; 66 is ASCII B and ISO Latin-1 B; and so on. Where ISO Latin-1 and ASCII diverge is in the characters between 128 and 255 (characters with high bit equal to one). ASCII does not define these characters. ISO Latin-1 uses them for various accented letters like ü needed for non-English languages written in a Roman script, additional punctuation marks and symbols like ©, and additional control characters. 

## Unicode

* Unicode is a 2-byte, 16-bit character set with 216 or 65,536 different possible characters. (Only about 40,000 are used in practice, the rest being reserved for future expansion.) Unicode can handle most of the world's living languages and a number of dead ones as well.
* Java streams do not do a good job of reading Unicode text. (This is why readers and writers were added in Java 1.1.) Streams generally read a byte at a time, but each Unicode character occupies two bytes. Thus, to read a Unicode character, you multiply the first byte read by 256, add it to the second byte read, and cast the result to a char. For example:

```java
 int b1 = in.read();
 int b2 = in.read();
 char c = (char) (b1*256 + b2);
 ```

## UTF-8

* Unicode is a relatively inefficient encoding when most of your text consists of ASCII characters. Every character requires the same number of bytes—two—even though some characters are used much more frequently than others. A more efficient encoding would use fewer bits for the more common characters. This is what UTF-8 does. 
* In UTF-8 the ASCII alphabet is encoded using a single byte, just as in ASCII. The next 1,919 characters are encoded in two bytes. The remaining Unicode characters are encoded in three bytes. However, since these three-byte characters are relatively uncommon, especially in English text, the savings achieved by encoding ASCII in a single byte more than makes up for it.
* Java's .class files use UTF-8 internally to store string literals. Data input streams and data output streams also read and write strings in UTF-8. However, this is all hidden from direct view of the programmer, unless perhaps you're trying to write a Java compiler or parse output of a data stream without using the DataInputStream class.

## Character set in Java 

Java understands several dozen different character sets for a variety of languages, ranging from ASCII to the Shift Japanese Input System (SJIS) to Unicode. Internally, Java uses the Unicode character set. Unicode is a two-byte extension of the one-byte ISO Latin-1 character set, which in turn is an eight-bit superset of the seven-bit ASCII character set.

# Miscellaneous
* http://www.ashishpaliwal.com/blog/2008/10/nio-frameworks-in-java/
* Apache MINA
* xSockets
* Grizzly
* Netty Non-blocking I/O Framework: http://www.manning.com/maurer/netty_meap_ch1.pdf

# Bibliography
* Oracle Certified Professional Java SE 7 (Chapter 8 & 9)
* OReilly - Java IO
* OReilly - Java NIO
* Apress - Pro Java 7 NIO.2
* http://docs.oracle.com/javase/tutorial/essential/io/