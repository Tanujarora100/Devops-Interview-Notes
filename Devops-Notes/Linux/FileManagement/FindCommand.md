
## Finding Files Modified in the Last 7 Days

```bash
find /path/to/directory -type f -mtime -7
```

## Finding Files Modified More Than 7 Days Ago
```bash
find /path/to/directory -type f -mtime +7
```

## Removing Files Modified More Than 7 Days Ago

To remove files that were modified more than 7 days ago, you can combine the `find` command with the `-exec` option or the `-delete` option:

### Using `-exec` Option

```bash
find /path/to/directory -type f -mtime +7 -exec rm {} \;
```

### Using `-delete` Option

```bash
find /path/to/directory -type f -mtime +7 -delete
```

## Finding Minimum and Maximum Modified Files

To find the minimum and maximum modified files, you can use the `ls` command in combination with `find` and `sort`:

### Finding the Most Recently Modified File (Minimum)

```bash
find /path/to/directory -type f -mtime -7 -exec ls -lrt {} + | head -n 1
```

### Finding the Oldest Modified File (Maximum)

```bash
find /path/to/directory -type f -mtime -7 -exec ls -lt {} + | tail -n 1
```

## Finding the Largest File

```bash
find / -type f -exec du -h {} + | sort -rh | head -n 1
```

## Finding the Smallest File

```bash
find / -type f -exec du -h {} + | sort -h | head -n 1
```


## Finding Files Modified in the Last 7 Days

```bash
find / -type f -mtime -7
```

## Finding Files Modified More Than 7 Days Ago

```bash
find / -type f -mtime +7
```
- **Explanation**:
  - `find / -type f`: Searches for all files starting from the root directory (`/`).
  - `-mtime +7`: Finds files modified more than 7 days ago.

## Removing Files Modified More Than 7 Days Ago

To remove files that were modified more than 7 days ago, you can use the `-delete` option with the `find` command:

```bash
find /path/to/directory -type f -mtime +7 -delete
```

- **Explanation**:
  - `find /path/to/directory -type f`: Searches for all files in the specified directory.
  - `-mtime +7`: Finds files modified more than 7 days ago.
  - `-delete`: Deletes the files found.

## FINDING FILES WITH PERMISSIONS
```bash
bob@ubuntu-host ~ ➜  find /var/log -perm -g=w > /home/bob/data.txt
```
## GREP FOR LAST WORD
![alt text](image-1.png)
## MATCH ANY CHARACTER IN BETWEEN
![alt text](image-2.png)
## ESCAPING SPECIAL CHARATCERS
![alt text](image-3.png)

## GREP FOR STARTING WORD
```bash
grep -i '^PS' <file_path>
# ^ Called Carrot Character
```
## Grep for Uncommented Lines
```bash
# -v is to invert the output or take not of output
grep -v '^#' <file_path>
```
## Case Insensitive Sed Command
```bash
# add i at the end
bob@ubuntu-host ~ ➜  sed -i s/disabled/enabled/gi values.conf 

```
## Stream Edit Within Specific Lines
```bash
sed -i '500,2000s/enabled/disabled/g' values.conf
```
