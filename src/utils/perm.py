p_line, total_filenames, max_filename_len, min_filename_len=input().split()
min_filename_len=int(min_filename_len)
glob_counter=[0, int(total_filenames), int(max_filename_len)]
answer_set=set()
chars=list(p_line)

def file_name_generator(lines, glob_counter, min_filename_len):
    full_line="".join(lines)
    if glob_counter[0]>=glob_counter[1]:
        return
    if full_line in answer_set:
        return
    if len(full_line)>glob_counter[2]:
        return
    if len(full_line)>=min_filename_len:
        answer_set.add(full_line)
        glob_counter[0]+=1
    for i in range(len(lines)):
        new_lines=lines[:]
        new_lines[i]=new_lines[i]+new_lines[i][0]
        file_name_generator(new_lines, glob_counter, min_filename_len)

file_name_generator(chars, glob_counter, min_filename_len)

print(*answer_set, sep='\n')
