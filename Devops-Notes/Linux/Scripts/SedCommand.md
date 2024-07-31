Here are the key points on how to delete lines using the sed command in Linux:

## Syntax

The general syntax for deleting lines with sed is:

```bash
sed '[line_number]d' [file_name]
```

Replace `[line_number]` with the line number you want to delete and `[file_name]` with the path to the text file.

## Examples

### Delete a specific line

To delete the 5th line from the file `input.txt`:

```bash
sed '5d' input.txt
```

### Delete a range of lines

To delete lines 3 through 5 from `input.txt`:

```bash
sed '3,5d' input.txt
```

### Delete all lines except a specific line

To keep only the 5th line and delete all others:

```bash
sed '1,4d;6,$d' input.txt
```

This deletes lines 1-4 and 6 to the end of file.

### Delete last line

To delete the last line of a file:

```bash
sed '$d' input.txt
```

The `$` represents the last line.

### Delete lines matching a pattern

To delete lines containing the word "error":

```bash
sed '/error/d' input.txt
```

This uses a regular expression to match lines with "error".

### Delete empty lines

To remove all blank lines:

```bash
sed '/^$/d' input.txt
```

The `^$` matches empty lines.

## Important Notes

- By default, sed prints the output with the changes. To modify the original file, use the `-i` option:

  ```bash
  sed -i '[line_number]d' [file_name]
  ```

- To save the changes to a new file instead, use output redirection:

  ```bash
  sed '[line_number]d' [file_name] > [new_file_name]
  ```