To install Go (Golang) on a Linux system, you can follow these steps. This guide covers downloading the Go binary, extracting it, and setting up the environment variables. These instructions are applicable to most Linux distributions, including Ubuntu.

## **Step-by-Step Installation Guide**

### **1. Download the Go Binary**

First, download the latest Go binary from the official Go website. You can use `wget` to download the tarball directly:

```sh
wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz
```

### **2. Extract the Archive**

Next, extract the downloaded tarball to the `/usr/local` directory:

```sh
sudo tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz
```

### **3. Set Up the Environment Variables**

To use Go, you need to add its binary directory to your `PATH` environment variable. You can do this by adding the following lines to your shell profile file (`~/.profile`, `~/.bashrc`, or `~/.zshrc`):

```sh
export PATH=$PATH:/usr/local/go/bin
```

For example, if you are using `bash`, you can edit `~/.bashrc`:

```sh
nano ~/.bashrc
```

Add the export line at the end of the file, then save and close the editor. To apply the changes, source the profile file:

```sh
source ~/.bashrc
```

### **4. Verify the Installation**

Finally, verify that Go is installed correctly by checking its version:

```sh
go version
```

You should see output indicating the installed version of Go, for example:

```sh
go version go1.21.4 linux/amd64
```

### **5. Optional: Set Up Go Workspace**

It is a good practice to set up a Go workspace. You can create a directory for your Go projects and set the `GOPATH` environment variable:

```sh
mkdir -p $HOME/go/{bin,src,pkg}
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$PATH:$GOPATH/bin" >> ~/.bashrc
source ~/.bashrc
```

## **Summary**

By following these steps, you will have Go installed on your Linux system and configured properly. You can now start developing applications using the Go programming language.

---

