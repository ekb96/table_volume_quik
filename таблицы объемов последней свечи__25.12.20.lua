--������ ������ ��������� ������� � �������� ��� ���� ��� ������� �����
--��� ����������������� ���������� ������� ������� ������������ ������, �������� ����������� ����������,
--� ������� ������������ ������ ����������� ������� - ��� �����������, ����, �����, ��������.
--� ������ ����������� �������� �������������� "Price" ��� �������,
--� ������� �������� ������ instr_code �� ������ ��� �����������,
--�������� ������ � QUIK, ��������� ������

myPrice		= "Price"																	--����� �������
--instr_code	= "BRU0"																--�������� ��� �����������
instr_code	= "SBER"																	--�������� ��� �����������
porog		= 10000																		--����� ������� �� ���������
-------------------------------------------------------------------------------------------------------------------
is_run = true
-------------------------------------------------------------------------------------------------------------------
function new_table()																	--������� �������� �������
	N = getNumCandles(myPrice)															--���������� ������ �� �������
	t,n,i = getCandlesByIndex(myPrice,0,N-1,1)											--������ ������� �����
	min_s = tonumber(t[0].datetime.min)													--������
	hour_s  = tonumber(t[0].datetime.hour)												--����
	if hour_s  < 10 then hour_s  = "0"..hour_s  end										--�������� "0" ����� ������
	if min_s   < 10 then min_s   = "0"..min_s   end										--�������� "0" ����� ������
	Time = hour_s..":"..min_s															--�����
	---------------------------------
	okno = AllocTable()
	AddColumn(okno,1,"����",true,QTABLE_INT_TYPE,10)									--������� "����"
	AddColumn(okno,2,"�������",true,QTABLE_INT_TYPE,10)									--������� "�������"
	AddColumn(okno,3,"�������",true,QTABLE_INT_TYPE,10)									--������� "�������"
	AddColumn(okno,4,"�����",true,QTABLE_INT_TYPE,12)									--������� "�����"
	CreateWindow(okno)																	--������� ����
	--SetWindowPos(okno,150,0,280,670)													--������� ����
	SetWindowPos(okno,0,0,280,670)														--������� ����
	SetWindowCaption(okno,"����� "..Time)												--�������� ����
	--InsertRow(okno,-1)																--�������� ������
end
----------------------------------------------------------------------------------------------------------------
function main()																			--������� �������
	message("������ ����".." / "..instr_code.." / "..porog,2)															
	z  = 0
	new_table()																			--������� ������ �������
	while is_run do
		N = getNumCandles(myPrice)														--���������� ������ �� �������
		t,n,i = getCandlesByIndex(myPrice,0,N-1,1)										--������ ������� �����
		min_s = tonumber(t[0].datetime.min)												--������
		hour_s  = tonumber(t[0].datetime.hour)											--����
		if hour_s  < 10 then hour_s  = "0"..hour_s  end									--�������� "0" ����� ������
		if min_s   < 10 then min_s   = "0"..min_s   end									--�������� "0" ����� ������
		Time = hour_s..":"..min_s														--�����
		if min_s0 ~= min_s and min_s0 ~= nil then										--���� ��������� ����� �����
			--z = 0																		--�������� ������
			
			--Clear(okno)																--���� �������� ����
			SetWindowCaption(okno,"����� "..Time)										--� �������� ����� � �������� ����
			
			--new_table()																--���� ������� �����
		end
		min_s0 = min_s
	    sleep(100)
		
		strok = GetTableSize(okno)														--�������� ���-�� ����� � �������
		for i = 1, strok do																--���� ������ ������� � ������� ����
			SetColor(okno,i,1,RGB(255,255,255),0,RGB(255,255,255),0)
		end
	end
end
----------------------------------------------------------------------------------------------------------------
function OnAllTrade(alltrade)															--������� ��������� ������������ ������ (�� ���������)
	all_code  = tostring(alltrade.sec_code)												--�������� ��� �����������
	all_price = tostring(alltrade.price)												--�������� ����
	all_qty   = tostring(alltrade.qty)													--�������� �����
	all_flags = tostring(alltrade.flags)												--�������� ���� (������� 1026 ��� ������� 1025)
	----------------------------------------------------------------------------------------------------------------
	if all_code == instr_code then														--���� ������ ��� �����������
		strok = GetTableSize(okno)														--�������� ���-�� ����� � �������
		if strok == 0 then																--���� ��� �� ����� ������ � �������
			InsertRow(okno,-1)															--�������� ������ ������
			z = z+1																		--��������� ������
			SetCell(okno,z,1,tostring(all_price))										--��������� ����
			if all_flags == "1026" then													--���� "�������"
				SetCell(okno,z,2,tostring(all_qty))										--�� ��������� ����� �������
			elseif all_flags == "1025" then												--���� "�������"
				SetCell(okno,z,3,tostring(all_qty))										--�� ��������� ����� �������
			end
			SetCell(okno,z,4,tostring(all_qty))											--�� ��������� ����� �����
		else																			--���� ���� ������ � �������
			for i = 1, strok do															--���� ������ ������� � ������� ����
				tab_price = GetCell(okno,i,1).image										--�������� ���� �� ������ � ��������
				tab_pokup = GetCell(okno,i,2).image										--�������� ����� �� ������ � ��������
				tab_prod  = GetCell(okno,i,3).image										--�������� ����� �� ������ � ��������
				tab_qty   = GetCell(okno,i,4).image										--�������� ����� ����� �� ������ � ��������
				tab_pokup = tonumber(tab_pokup)											--������������� � �����
				tab_prod  = tonumber(tab_prod)											--������������� � �����
				tab_qty   = tonumber(tab_qty)											--������������� � �����
				----------------------------------------------------------------------------------------------------
				if all_price > tab_price then											--���� ����� ���� ������ ������
					InsertRow(okno,1)													--�� �������� ����� ������ ����� ������� ������
					z = z + 1															--��������� ������
					SetCell(okno,1,1,tostring(all_price))								--�������� ����
					if all_flags == "1026" then											--���� "�������"
						SetCell(okno,1,2,tostring(all_qty))								--�� �������� ����� �������
					elseif all_flags == "1025" then										--���� "�������"
						SetCell(okno,1,3,tostring(all_qty))								--�� �������� ����� �������
					end
					SetCell(okno,1,4,tostring(all_qty))									--�� ��������� ����� �����
					---------------------------------------------
					if tonumber(all_qty)<6 then											--���� ������ ������� ������ ���������� �������
						SetColor(okno,1,4,RGB(0,255,255),0,RGB(0,255,255),0)			--������ ���� ����(������ 1,������� 4,������� ���,������ �����)
					end
					SetColor(okno,1,1,RGB(0,255,255),0,RGB(0,255,255),0)				--������ ���� ����(������ i,������� 1,������� ���,������ �����)
					---------------------------------------------
					break																--��������� ���� "for"
				elseif tab_price == all_price then										--���� ����� ���� ����� ���� �� ������
					tab_qty = tab_qty + all_qty
					SetCell(okno,i,4,tostring(tab_qty))									--������������ ����� �����
					---------------------------------------------
					if tonumber(tab_qty)>porog then										--���� ����� ����� ������ ���������� �������
						--rgb1 = RGB(255,0,0)											--���� ����1/�������
						--rgb1 = RGB(0,255,0)											--���� ����1/�������
						rgb1 = RGB(255,255,0)											--���� ����1/������
					elseif tonumber(tab_qty)<6 then										--���� ����� ����� ������ ���������� �������
						rgb1 = RGB(0,255,255)											--���� ����1/�������
					else
						rgb1 = RGB(255,255,255)											--���� ����1/�����
					end
					SetColor(okno,i,4,rgb1,0,rgb1,0)									--������ ���� ����(������ i,������� 4,���,������ �����)
					---------------------------------------------
					if all_flags == "1026" and tab_pokup ~= nil then					--���� "�������" � ���� �� ������
						all_qty = tab_pokup + all_qty									--�� ������� ������
						SetCell(okno,i,2,tostring(all_qty))								--� ������������ �����
					elseif all_flags == "1026" and tab_pokup == nil then				--���� "�������" � ���� ������
						all_qty = all_qty												--�� ������ ������ �����
						SetCell(okno,i,2,tostring(all_qty))								--� ������������
					elseif all_flags == "1025" and tab_prod ~= nil then					--���� "�������" � ���� �� ������
						all_qty = tab_prod + all_qty									--�� ������� ������
						SetCell(okno,i,3,tostring(all_qty))								--� ������������
					elseif all_flags == "1025" and tab_prod == nil then					--���� "�������" � ���� ������
						all_qty = all_qty												--�� ������ ������ �����
						SetCell(okno,i,3,tostring(all_qty))								--� ������������
					end
					---------------------------------------------
					SetColor(okno,i,1,RGB(0,255,255),0,RGB(0,255,255),0)				--������ ���� ����(������ i,������� 1,������� ���,������ �����)
					---------------------------------------------
					break																--��������� ���� "for"
				elseif all_price < tab_price and i+1 <= strok and all_price > GetCell(okno,i+1,1).image then						
					--���� ���� ������ ���� � ������ i � ������ i+1 < ����� �����
					--���� ���� ������ ���� � ������ i+1
						InsertRow(okno, i+1)											--�� �������� ������������� ������ i+1
						z = z + 1														--��������� ������
						SetCell(okno,i+1,1,tostring(all_price))							--�������� ����
						if all_flags == "1026" then										--���� "�������"
							SetCell(okno,i+1,2,tostring(all_qty))						--�� �������� ����� �������
						elseif all_flags == "1025" then									--���� "�������"
							SetCell(okno,i+1,3,tostring(all_qty))						--�� �������� ����� �������
						end
						SetCell(okno,i+1,4,tostring(all_qty))							--�� ��������� ����� �����
						---------------------------------------------
						if tonumber(all_qty)<6 then										--���� ������ ������� ������ ���������� �������
							SetColor(okno,i+1,4,RGB(0,255,255),0,RGB(0,255,255),0)		--������ ���� ����(������ z,������� 4,������� ���,������ �����)
						end
						SetColor(okno,i+1,1,RGB(0,255,255),0,RGB(0,255,255),0)			--������ ���� ����(������ z,������� 1,������� ���,������ �����)
						---------------------------------------------
					break																--��������� ���� "for"
				elseif i == strok then													--���� �� ����� �������� ��� ������
					InsertRow(okno,-1)													--�� �������� ������ � �����
					z = z + 1															--��������� ������
					SetCell(okno,z,1,tostring(all_price))								--�������� ����
					if all_flags == "1026" then											--���� "�������"
						SetCell(okno,z,2,tostring(all_qty))								--�� �������� ����� �������
					elseif all_flags == "1025" then										--���� "�������"
						SetCell(okno,z,3,tostring(all_qty))								--�� �������� ����� �������
					end
					SetCell(okno,z,4,tostring(all_qty))									--�� ��������� ����� �����
					---------------------------------------------
					if tonumber(all_qty)<6 then											--���� ������ ������� ������ ���������� �������
						SetColor(okno,z,4,RGB(0,255,255),0,RGB(0,255,255),0)			--������ ���� ����(������ z,������� 4,������� ���,������ �����)
					end
					SetColor(okno,z,1,RGB(0,255,255),0,RGB(0,255,255),0)				--������ ���� ����(������ z,������� 1,������� ���,������ �����)
					---------------------------------------------
					break																--��������� ���� "for"
				end
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------
function OnStop(stop_flag)																--������� ��������� �������
	is_run = false
	DestroyTable(okno)																	--������� ����1
	message("������ ����".." / "..instr_code,3)
end
----------------------------------------------------------------------------------------------------------------
--for x = 1, strok do															--���� ������ �������
--	qty_   = GetCell(okno,x,4).image											--�������� ����� ����� �� ������ � ��������
--	qty_   = tonumber(qty_)														--������������� � �����
--end
--X_max = math.max(Close5,Close4,Close3,Close2,Close1)