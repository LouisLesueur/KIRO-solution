function list_to_string(list)
    sol_string = ""
    for elem in list
        sol_string = string(sol_string, string(elem), " ")
    end
    return chop(sol_string)
end


function create_output_file(filename, list_ss_trt, global_list_turns, list_groups)
    open(filename, "w") do file
        # First line
        nb_ss_trt = length(list_ss_trt)
        str_list_ss_trt = list_to_string([i- 1 for i in list_ss_trt])
        first_line = string("x ", nb_ss_trt, " f ", str_list_ss_trt, "\n")
        write(file, first_line)

        # Second line
        nb_turn = 0
        for trn in global_list_turns
            nb_turn += length(trn[3])
        end
        second_line = string("y ", nb_turn, "\n")
        write(file, second_line)

        # Third line
        nb_groups = length(list_groups)
        third_line = string("z ", nb_groups, "\n")
        write(file, third_line)

        # Group lines
        for (i,group) in enumerate(list_groups)
            out_group = [i-1 for i in group]
            nb_furn = length(out_group)
            str_grp = list_to_string(out_group)
            crnt_grp_line = string("C ", i-1, " n ", nb_furn, " f ", str_grp, "\n")
            write(file, crnt_grp_line)
        end

        # Turns lines
        count = 0
        for turns_data in global_list_turns
            week = turns_data[1]
            group_id = turns_data[2]
            list_turns = turns_data[3]
            # println(list_turns)
            for turn in list_turns
                # println(turn)
                nb_furn = length(turn)
                crnt_turn_line = string("P ", count, " g ", group_id-1, " s ", week-1, " n " , nb_furn)
                for furn in turn
                    f_idx, f_quant = furn
                    crnt_turn_line = string(crnt_turn_line, " f ", f_idx-1, " ", f_quant)
                end
                crnt_turn_line = string(crnt_turn_line, "\n")
                write(file, crnt_turn_line)
                count += 1
            end
        end
    end
end

# create_output_file("test.txt",
#                   [1,5,7],
#                   [[1, 1, [[(2, 3), (3, 5)], [(2,4)]]], [2, 1, [[(3, 1), (2, 4)]]],[1, 2, [[(4, 5), (6, 1), (8, 10)]]], [2, 2, [[(8, 2), (6,10), (4,9)]]]],
#                   [[2,3],[4,6,8]])
