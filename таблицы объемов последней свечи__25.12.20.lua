--данный скрипт формирует таблицу с объемами для всех цен текущей свечи
--для работоспособности необходимо открыть таблицу обезличенных сделок, добавить необходимый инструмент,
--в таблице обезличенных сделок обязательны колонки - код инструмента, цена, объем, операция.
--в график инструмента добавить индентификатор "Price" без ковычек,
--в скрипте изменить строку instr_code на нужный код инструмента,
--добавить скрипт в QUIK, запустить скрипт

myPrice		= "Price"																	--метка графика
--instr_code	= "BRU0"																--заданный код инструмента
instr_code	= "SBER"																	--заданный код инструмента
porog		= 10000																		--порог индекса дл¤ подсветки
-------------------------------------------------------------------------------------------------------------------
is_run = true
-------------------------------------------------------------------------------------------------------------------
function new_table()																	--функция создания таблицы
	N = getNumCandles(myPrice)															--количество свечей на графике
	t,n,i = getCandlesByIndex(myPrice,0,N-1,1)											--данные текущей свечи
	min_s = tonumber(t[0].datetime.min)													--минуты
	hour_s  = tonumber(t[0].datetime.hour)												--часы
	if hour_s  < 10 then hour_s  = "0"..hour_s  end										--добавить "0" перед цифрой
	if min_s   < 10 then min_s   = "0"..min_s   end										--добавить "0" перед цифрой
	Time = hour_s..":"..min_s															--время
	---------------------------------
	okno = AllocTable()
	AddColumn(okno,1,"Цена",true,QTABLE_INT_TYPE,10)									--колонка "цена"
	AddColumn(okno,2,"Покупка",true,QTABLE_INT_TYPE,10)									--колонка "покупка"
	AddColumn(okno,3,"Продажа",true,QTABLE_INT_TYPE,10)									--колонка "продажа"
	AddColumn(okno,4,"Общий",true,QTABLE_INT_TYPE,12)									--колонка "общий"
	CreateWindow(okno)																	--создать окно
	--SetWindowPos(okno,150,0,280,670)													--размеры окна
	SetWindowPos(okno,0,0,280,670)														--размеры окна
	SetWindowCaption(okno,"Объем "..Time)												--название окна
	--InsertRow(okno,-1)																--добавить строку
end
----------------------------------------------------------------------------------------------------------------
function main()																			--главная функция
	message("ОБЪЕМЫ ПУСК".." / "..instr_code.." / "..porog,2)															
	z  = 0
	new_table()																			--создать первую таблицу
	while is_run do
		N = getNumCandles(myPrice)														--количество свечей на графике
		t,n,i = getCandlesByIndex(myPrice,0,N-1,1)										--данные текущей свечи
		min_s = tonumber(t[0].datetime.min)												--минуты
		hour_s  = tonumber(t[0].datetime.hour)											--часы
		if hour_s  < 10 then hour_s  = "0"..hour_s  end									--добавить "0" перед цифрой
		if min_s   < 10 then min_s   = "0"..min_s   end									--добавить "0" перед цифрой
		Time = hour_s..":"..min_s														--время
		if min_s0 ~= min_s and min_s0 ~= nil then										--если открылась новая свеча
			--z = 0																		--обнулить индекс
			
			--Clear(okno)																--либо очистить окно
			SetWindowCaption(okno,"Объем "..Time)										--и изменить время в названии окна
			
			--new_table()																--либо создать новое
		end
		min_s0 = min_s
	    sleep(100)
		
		strok = GetTableSize(okno)														--получает кол-во строк в таблице
		for i = 1, strok do																--цикл обхода таблицы в поисках цены
			SetColor(okno,i,1,RGB(255,255,255),0,RGB(255,255,255),0)
		end
	end
end
----------------------------------------------------------------------------------------------------------------
function OnAllTrade(alltrade)															--функция получения обезличенных сделок (по изменению)
	all_code  = tostring(alltrade.sec_code)												--получаем код инструмента
	all_price = tostring(alltrade.price)												--получаем цену
	all_qty   = tostring(alltrade.qty)													--получаем объем
	all_flags = tostring(alltrade.flags)												--получаем флаг (покупка 1026 или продажа 1025)
	----------------------------------------------------------------------------------------------------------------
	if all_code == instr_code then														--если нужный код инструмента
		strok = GetTableSize(okno)														--получает кол-во строк в таблице
		if strok == 0 then																--если нет ни одной строки в таблице
			InsertRow(okno,-1)															--добавить первую строку
			z = z+1																		--увеличить индекс
			SetCell(okno,z,1,tostring(all_price))										--заполнить цену
			if all_flags == "1026" then													--если "покупка"
				SetCell(okno,z,2,tostring(all_qty))										--то заполнить объем покупки
			elseif all_flags == "1025" then												--если "продажа"
				SetCell(okno,z,3,tostring(all_qty))										--то заполнить объем продажи
			end
			SetCell(okno,z,4,tostring(all_qty))											--то заполнить общий объем
		else																			--если есть строки в таблице
			for i = 1, strok do															--цикл обхода таблицы в поисках цены
				tab_price = GetCell(okno,i,1).image										--получить цену из строки с индексом
				tab_pokup = GetCell(okno,i,2).image										--получить объем из строки с индексом
				tab_prod  = GetCell(okno,i,3).image										--получить объем из строки с индексом
				tab_qty   = GetCell(okno,i,4).image										--получить общий объем из строки с индексом
				tab_pokup = tonumber(tab_pokup)											--преобразовать к числу
				tab_prod  = tonumber(tab_prod)											--преобразовать к числу
				tab_qty   = tonumber(tab_qty)											--преобразовать к числу
				----------------------------------------------------------------------------------------------------
				if all_price > tab_price then											--если новая цена больше первой
					InsertRow(okno,1)													--то добавить новую строку перед текущей первой
					z = z + 1															--увеличить индекс
					SetCell(okno,1,1,tostring(all_price))								--записать цену
					if all_flags == "1026" then											--если "покупка"
						SetCell(okno,1,2,tostring(all_qty))								--то записать объем покупки
					elseif all_flags == "1025" then										--если "продажа"
						SetCell(okno,1,3,tostring(all_qty))								--то записать объем продажи
					end
					SetCell(okno,1,4,tostring(all_qty))									--то заполнить общий объем
					---------------------------------------------
					if tonumber(all_qty)<6 then											--если индекс баланса меньше порогового значени¤
						SetColor(okno,1,4,RGB(0,255,255),0,RGB(0,255,255),0)			--задать цвет фона(строка 1,колонка 4,морской фон,черный текст)
					end
					SetColor(okno,1,1,RGB(0,255,255),0,RGB(0,255,255),0)				--задать цвет фона(строка i,колонка 1,морской фон,черный текст)
					---------------------------------------------
					break																--закончить цикл "for"
				elseif tab_price == all_price then										--если новая цена равна цене из строки
					tab_qty = tab_qty + all_qty
					SetCell(okno,i,4,tostring(tab_qty))									--перезаписать общий объем
					---------------------------------------------
					if tonumber(tab_qty)>porog then										--если общий объем больше порогового значени¤
						--rgb1 = RGB(255,0,0)											--цвет фона1/красный
						--rgb1 = RGB(0,255,0)											--цвет фона1/зеленый
						rgb1 = RGB(255,255,0)											--цвет фона1/желтый
					elseif tonumber(tab_qty)<6 then										--если общий объем больше порогового значени¤
						rgb1 = RGB(0,255,255)											--цвет фона1/морской
					else
						rgb1 = RGB(255,255,255)											--цвет фона1/белый
					end
					SetColor(okno,i,4,rgb1,0,rgb1,0)									--задать цвет фона(строка i,колонка 4,фон,черный текст)
					---------------------------------------------
					if all_flags == "1026" and tab_pokup ~= nil then					--если "покупка" и окно не пустое
						all_qty = tab_pokup + all_qty									--то сложить объемы
						SetCell(okno,i,2,tostring(all_qty))								--и перезаписать объем
					elseif all_flags == "1026" and tab_pokup == nil then				--если "покупка" и окно пустое
						all_qty = all_qty												--то только данный объем
						SetCell(okno,i,2,tostring(all_qty))								--и перезаписать
					elseif all_flags == "1025" and tab_prod ~= nil then					--если "продажа" и окно не пустое
						all_qty = tab_prod + all_qty									--то сложить объемы
						SetCell(okno,i,3,tostring(all_qty))								--и перезаписать
					elseif all_flags == "1025" and tab_prod == nil then					--если "продажа" и окно пустое
						all_qty = all_qty												--то только данный объем
						SetCell(okno,i,3,tostring(all_qty))								--и перезаписать
					end
					---------------------------------------------
					SetColor(okno,i,1,RGB(0,255,255),0,RGB(0,255,255),0)				--задать цвет фона(строка i,колонка 1,морской фон,черный текст)
					---------------------------------------------
					break																--закончить цикл "for"
				elseif all_price < tab_price and i+1 <= strok and all_price > GetCell(okno,i+1,1).image then						
					--если цена меньше цены в строке i и индекс i+1 < числа строк
					--если цена больше цены в строке i+1
						InsertRow(okno, i+1)											--то добавить промежуточную строку i+1
						z = z + 1														--увеличить индекс
						SetCell(okno,i+1,1,tostring(all_price))							--записать цену
						if all_flags == "1026" then										--если "покупка"
							SetCell(okno,i+1,2,tostring(all_qty))						--то записать объем покупки
						elseif all_flags == "1025" then									--если "продажа"
							SetCell(okno,i+1,3,tostring(all_qty))						--то записать объем продажи
						end
						SetCell(okno,i+1,4,tostring(all_qty))							--то заполнить общий объем
						---------------------------------------------
						if tonumber(all_qty)<6 then										--если индекс баланса меньше порогового значени¤
							SetColor(okno,i+1,4,RGB(0,255,255),0,RGB(0,255,255),0)		--задать цвет фона(строка z,колонка 4,морской фон,черный текст)
						end
						SetColor(okno,i+1,1,RGB(0,255,255),0,RGB(0,255,255),0)			--задать цвет фона(строка z,колонка 1,морской фон,черный текст)
						---------------------------------------------
					break																--закончить цикл "for"
				elseif i == strok then													--если не нашел перебрав все строки
					InsertRow(okno,-1)													--то добавить строку в конец
					z = z + 1															--увеличить индекс
					SetCell(okno,z,1,tostring(all_price))								--записать цену
					if all_flags == "1026" then											--если "покупка"
						SetCell(okno,z,2,tostring(all_qty))								--то записать объем покупки
					elseif all_flags == "1025" then										--если "продажа"
						SetCell(okno,z,3,tostring(all_qty))								--то записать объем продажи
					end
					SetCell(okno,z,4,tostring(all_qty))									--то заполнить общий объем
					---------------------------------------------
					if tonumber(all_qty)<6 then											--если индекс баланса меньше порогового значени¤
						SetColor(okno,z,4,RGB(0,255,255),0,RGB(0,255,255),0)			--задать цвет фона(строка z,колонка 4,морской фон,черный текст)
					end
					SetColor(okno,z,1,RGB(0,255,255),0,RGB(0,255,255),0)				--задать цвет фона(строка z,колонка 1,морской фон,черный текст)
					---------------------------------------------
					break																--закончить цикл "for"
				end
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------
function OnStop(stop_flag)																--функция остановки скрипта
	is_run = false
	DestroyTable(okno)																	--закрыть окно1
	message("ОБЪЕМЫ СТОП".." / "..instr_code,3)
end
----------------------------------------------------------------------------------------------------------------
--for x = 1, strok do															--цикл обхода таблицы
--	qty_   = GetCell(okno,x,4).image											--получить общий объем из строки с индексом
--	qty_   = tonumber(qty_)														--преобразовать к числу
--end
--X_max = math.max(Close5,Close4,Close3,Close2,Close1)