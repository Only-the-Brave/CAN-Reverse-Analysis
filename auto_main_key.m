id_seq = str2num(app.IDEditField_5.Value);
amount_seq = str2num(app.EditField_19.Value);
opt_int_moto = app.DropDown_6.Value;
fig_str4 = app.EditField_11.Value;
signal_judge = app.DropDown_8.Value;
for i = id_seq
    P = app.CAN_A.id(i);
    opt_int_id = app.CAN_ID_cell.(P);
    fig_id = opt_int_id.id(1);
    table_bl_dbc = table([7 6 5 4 3 2 1 0 15 14 13 12 11 10 9 8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24 39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56 ]',[1:64]','VariableNames',{'dbc_Sta','bl_sta',});
    %switch语句
    switch opt_int_moto
        case 'Intel'
            opt_int_id.x09= [opt_int_id.x08,opt_int_id.x07,opt_int_id.x06,opt_int_id.x05,opt_int_id.x04,opt_int_id.x03,opt_int_id.x02,opt_int_id.x01];
            for range_bit = amount_seq    %       start_bit = 64-input('请输入起始位（范围0-63）：');
                for start_bit = range_bit:64
                    a = opt_int_id{:,12};
                    b = a(:,start_bit-range_bit+1:start_bit);
                    size_b =size(b);
                    ku = size_b(2);
                    size_b_2 = size_b(1,1);
                    q = 1;
                    while q < size_b_2
                        judge_b = strcmp(b(q,:),b(q+1,:));
                        q = q+1;
                        if judge_b == 0
                            x = opt_int_id.time;
                            if signal_judge == "unsigned"
                                y = bin2dec(b);
                            elseif signal_judge == "signed"
                                signed_bit = b(:,1);
                                for p = 1:size_b_2
                                    if signed_bit(p) == '0'
                                        opt_int_id.x10(p,:) = bin2dec(b(p,:));
                                    elseif signed_bit(p) == '1'
                                        opt_int_id.x10(p,:) = (2^ku - bin2dec(b(p,:)))*-1;
                                    else
                                        return
                                    end
                                end
                                y = opt_int_id.x10;
                            end
                            plot(app.UIAxes,x,y);
                            app.UIAxes.Title.String = sprintf('ID是%s；起始位是%s；信号位数是%s',fig_id,num2str(64-start_bit),num2str(range_bit));
                            exportgraphics(app.UIAxes,[fig_str4,sprintf('ID%s_%s_%s',fig_id,num2str(64-start_bit),num2str(range_bit)),'.jpg']);
                            close;
                            break
                        elseif q == size_b_2
                            break
                        end
                    end
                end
            end
        case 'Motorola'
            opt_int_id.x09= [opt_int_id.x01,opt_int_id.x02,opt_int_id.x03,opt_int_id.x04,opt_int_id.x05,opt_int_id.x06,opt_int_id.x07,opt_int_id.x08];
            for range_bit = amount_seq
                for start_bit_m = range_bit:64
                    bl_row = table_bl_dbc.bl_sta(:) == start_bit_m;
                    bl_index = find(bl_row);
                    dbc_num = table_bl_dbc.dbc_Sta(bl_index);
                    a = opt_int_id{:,12};
                    b = a(:,start_bit_m-range_bit+1:start_bit_m);
                    size_b =size(b);
                    ku = size_b(2);
                    size_b_2 = size_b(1,1);
                    q = 1;
                    while q < size_b_2
                        judge_b = strcmp(b(q,:),b(q+1,:));
                        q = q+1;
                        if judge_b == 0
                            x = opt_int_id.time;
                            if signal_judge == "unsigned"
                                y = bin2dec(b);
                            elseif signal_judge == "signed"
                                signed_bit = b(:,1);
                                for p = 1:size_b_2
                                    if signed_bit(p) == '0'
                                        opt_int_id.x10(p,:) = bin2dec(b(p,:));
                                    elseif signed_bit(p) == '1'
                                        opt_int_id.x10(p,:) = (2^ku - bin2dec(b(p,:)))*-1;
                                    else
                                        return
                                    end
                                end
                                y = opt_int_id.x10;
                            end
                            plot(app.UIAxes,x,y);
                            app.UIAxes.Title.String = sprintf('ID是%s；起始位是%s；信号位数是%s',fig_id,num2str(dbc_num),num2str(range_bit));
                            exportgraphics(app.UIAxes,[fig_str4,sprintf('ID%s_%s_%s',fig_id,num2str(dbc_num),num2str(range_bit)),'.jpg']);
                            close;
                            break
                        elseif q == size_b_2
                            break
                        end
                    end
                end
            end
        otherwise
            disp('你的输入不符合要求，请按要求输入：')
    end
end
msgbox("自定义遍历完成","提示");