import vim
import sys
import os

_COMMENT_CHARS = {
    '.py': '#',
    '.cpp': '//',
    '.hpp': '//',
    '.h': '//',
    '.c': '//',
    '.txt': '//',
    '.pl': '#',
    '.js': '//',
    '.vim': '"'
}

_CLOSING_PARTNERS = {
    '(':')',
    '[':']',
    '{':'}',
    '"':'"',
    "'":"'"
}


# normalizes the mark to be 0 indexed and no longer than the length of the line
def get_mark(pos):
    buf = vim.current.buffer
    row = pos[0]
    col = pos[1]
    row = row - 1

    if col >= len(buf[row]) - 1:
        col = len(buf[row]) - 1

    if not buf[row].strip():
        col = 0
 
    return (row,col) 

def selected_lines():
    buf = vim.current.buffer

    first_mark = buf.mark('<')
    first_tuple = get_mark(first_mark)
    second_mark = buf.mark('>')
    second_tuple = get_mark(second_mark)

    start = first_tuple[0]
    end = second_tuple[0]
    return (start, end)


def get_text(start, end):
    buf = vim.current.buffer
    ret_buf = []
    for line_no in range(start, end + 1):
        ret_buf.append(buf[line_no])
    return ret_buf


def set_text(start, end, block):
    buf = vim.current.buffer
    line_no = 0
    for buf_line in range(start, end + 1):
        buf[buf_line] = block[line_no]
        line_no = line_no + 1


def get_comment_char():
    buf_name = vim.current.buffer.name
    base = os.path.basename(buf_name)
    file_parts = os.path.splitext(base)
    if file_parts[0] == 'vimrc':
        # hack for the vim setup i've got going
        return _COMMENT_CHARS['.vim']
    file_type = file_parts[1]
    try:
        return _COMMENT_CHARS[file_type]
    except KeyError:
        return ''


def comment_block(args):
    buf = vim.current.buffer
    comment_char = get_comment_char()
    start, end = selected_lines()
    for line_no in range(start, end + 1):
        buf[line_no] = comment_char + buf[line_no]


def uncomment_block(args):
    buf = vim.current.buffer
    comment_char = get_comment_char()
    start, end = selected_lines()
    for line_no in range(start, end + 1):
        curr_line = buf[line_no]
        if curr_line.startswith(comment_char):
            buf[line_no] = curr_line.replace(comment_char, '', 1)


def comma_list(block):
    ret_block = []
    for line in block:
        words = line.split(' ')
        new_line = ''
        for word in words:
           new_line = new_line + word + ', '
        ret_block.append(new_line)

    # remove the trailing comma from the last line
    ret_block[-1] = ret_block[-1][:-1]  

    return ret_block
    

def quote_list(char, block):
    ret_block = []
    for line in block:
        line = line.strip()
        words = line.split(' ')
        new_line = ''
        for word in words:
           new_line = new_line + char + word.strip() + char + ' ' 

        new_line = new_line.strip()
        ret_block.append(new_line)

    return ret_block


def make_list(args):
    start, end = selected_lines()
    block = get_text(start, end)
    block = quote_list(args[0], block)
    block = comma_list(block)
    set_text(start, end, block)


def dict_list(block):
    ret_block = []
    for line in block:
        words = line.split(' ')
        if len(words) != 2:
            raise ValueError('For making dict, expect lines of <word word>')
        new_line = words[0] + ': ' + words[1] + ','
        ret_block.append(new_line)
    # remove the trailing comma from the last line
    ret_block[-1] = ret_block[-1][:-1]  
    return ret_block
    
def make_dict(args):
    start, end = selected_lines()
    block = get_text(start, end)
    try:
        quote_block = quote_list(args[0], block)
        quote_block = dict_list(quote_block)
        set_text(start, end, quote_block)
    except ValueError:
        set_text(start, end, block)

def open_char(args):
    buf = vim.current.buffer
    (row, col) = vim.current.window.cursor
    buffer_row = row - 1
    curr_line = buf[buffer_row]
    line_size = len(curr_line)
    open_c = args[0]
    close_c = _CLOSING_PARTNERS[open_c]
    # first thing on the line
    if not line_size:
        curr_line = open_c + close_c 
    # after the end of the line
    elif line_size == col:
        curr_line = curr_line + open_c + close_c
    # on a space
    elif curr_line[col] == ' ':
        curr_line = curr_line[:col] + open_c + close_c + curr_line[col:]
    # on a character
    else:
        if open_c != '"' and open_c != "'":
            curr_line = curr_line[:col] + open_c + curr_line[col:]
        elif open_c == "'" and curr_line[col] != "'":
            curr_line = curr_line[:col] + open_c + curr_line[col:]
        elif open_c == '"' and curr_line[col] != '"':
            curr_line = curr_line[:col] + open_c + curr_line[col:]
    buf[buffer_row] = curr_line
    vim.current.window.cursor = (row,col + 1)


def jump_char(args):
    buf = vim.current.buffer
    (row, col) = vim.current.window.cursor
    buffer_row = row - 1
    curr_line = buf[buffer_row]
    line_size = len(curr_line)
    open_c = args[0]
    close_c = _CLOSING_PARTNERS[open_c]
    write = True
    if not line_size:
        curr_line = close_c
    elif line_size == col:
        curr_line = curr_line + close_c
    elif curr_line[col] == close_c:
        write = False
    else:
        curr_line = curr_line[:col] + close_c + curr_line[col:]

    if write:
        buf[buffer_row] = curr_line

    vim.current.window.cursor = (row, col + 1)



def insert_import(buf, imp):
    # check for file level imports which means they should all be at the top
    imp_starts = {'import', 'from'}
    found_imp = False
    for line_no, line in enumerate(buf):
        line = line.strip()
        if not line:
            continue
        first_word = line.split(' ')[0]
        if first_word not in imp_starts:
            # found a non blank line that doesn't start with imp
            break
        elif line == imp:
            found_imp = True
            break

    if not found_imp:
        # we didn't find this import so return the line where we should insert
        return line_no
    else:
        return None


def insert_ipdb(args):
    imp = 'import ipdb'
    ins = 'ipdb.set_trace()'
    buf = vim.current.buffer
    (row, col) = get_mark(vim.current.window.cursor)
    insert_pos = insert_import(buf, imp)
    if insert_pos and row > insert_pos:
        buf.append('', insert_pos)
        buf.append(imp, insert_pos)
        buf.append('', insert_pos)

        # increase the row # by 3 as we've added 3 lines
        buf.append(ins, row + 3)
        vim.current.window.cursor = (row + 4, col)
    elif not insert_pos:
        buf.append(ins, row)
        vim.current.window.cursor = (row + 1, col)
    

def delete_ipdb(args):
    to_delete = {'import ipdb', 'ipdb.set_trace()'}
    buf = vim.current.buffer
    delete_lines = []
    for indx, line in enumerate(buf):
        if line.strip() in to_delete: 
            delete_lines.append(indx)

    for indx in reversed(delete_lines):
        del buf[indx]


# assumes that backspace was pressed and the char to be deleted
# is to the left of the cursor
def delete_char(args):
    buf = vim.current.buffer
    (row, col) = get_mark(vim.current.window.cursor)
    # if we're at the beginning don't do anything or not about to backspace over
    # something that has a pair
    if not col or buf[row][col - 1] not in _CLOSING_PARTNERS:
        return
    close = _CLOSING_PARTNERS[buf[row][col - 1]]
    steps = 1    
    delete = False
    for c in buf[row][col:]:
        if c == ' ':
            steps = steps + 1
        elif c == close:
            # steps either started at 1 or was incremented at end of last loop (when we saw a space)
            delete = True
            break
        else:
            break

    # if we found an opening and closing pair with nothing but space between,
    # go ahead and get rid of them and the space
    if delete:
        buf[row] = buf[row][:col] + buf[row][col + steps:]


# useful for debugging
def vdbg(line):
    log_file = os.path.join(os.path.expanduser('~'), '.vim', 'log.txt')
    with open(log_file, 'a') as my_log:
        my_log.write(str(line))
        my_log.write('\n')


def functions():
    func_dir = {
        'comment': comment_block,
        'uncomment': uncomment_block,
        'list': make_list,
        'dict': make_dict,
        'open_char': open_char,
        'jump_char': jump_char,
        'insert_ipdb': insert_ipdb,
        'delete_ipdb': delete_ipdb,
        'delete_char': delete_char
    }

    return func_dir


if __name__ == '__main__':
    args = sys.argv
    if len(args) > 0:
        try:
            func = functions()[args[0]]
            func(args[1:])
        except KeyError:
            print(args[0] + ' not recognized as a command')
