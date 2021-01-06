
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВерсияСсылка = Параметры.ВерсияСсылка;
	ВладелецВерсии = ВерсияСсылка.Владелец;
	ПутьСохранения = РаботаСФайламиВызовСервера.ПолучитьИмяСохраненияВерсии(ВерсияСсылка);
	
	Заголовок = НСтр("ru = 'Восстановление версии файла ""'") + Строка(ВерсияСсылка.Владелец) + "." + ВерсияСсылка.Расширение + """";
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ЗначениеЗаполнено(ПутьСохранения) Тогда
		ТекстОшибки = НСтр("ru = 'Укажите путь файла версии'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПутьСохранения", , Отказ);
	КонецЕсли;	
	
	Если Не ПустаяСтрока(ПутьСохранения) И (Лев(ПутьСохранения, 2) <> "\\" ИЛИ Найти(ПутьСохранения, ":") <> 0) Тогда
		ТекстОшибки = НСтр("ru = 'Путь файла версии должен быть в формате UNC (\\servername\resource\ИмяФайла.Расширение)'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПутьСохранения", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;	
	
	Если ВосстановитьСервер() Тогда
		Закрыть(КодВозвратаДиалога.ОК);
		Оповестить("ВерсияВосстановлена", ВладелецВерсии);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ВосстановитьСервер()
	
	Перем СсылкаНаТом;
	
	Файл = Новый Файл(ПутьСохранения);
	Если Не Файл.Существует() Тогда
		
		ТекстОшибки = НСтр("ru = 'Файл по указанному пути отсутствует. Укажите другой путь (в формате UNC)'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПутьСохранения");
		
		Возврат Ложь;
		
	КонецЕсли;	
	
	ВерсияОбъект = ВерсияСсылка.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ВерсияСсылка);
	
	ВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВерсияОбъект.Владелец, "ВладелецФайла");
	
	НачатьТранзакцию();
	Попытка
	
		ВерсияОбъект.ФайлУдален = Ложь;
		
		Если ВерсияОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
			
			ДвоичныеДанные = Новый ДвоичныеДанные(ПутьСохранения);
			ХранилищеФайла = Новый ХранилищеЗначения(ДвоичныеДанные);
			РаботаСФайламиВызовСервера.ЗаписатьФайлВИнформационнуюБазу(ВерсияСсылка, ХранилищеФайла);
			
		Иначе
			
			НовыйПутьКФайлу = "";
			
			ФайловыеФункции.ДобавитьНаДиск(ПутьСохранения, НовыйПутьКФайлу, СсылкаНаТом, 
				ВерсияСсылка.ДатаМодификацииУниверсальная, 
				ВерсияСсылка.НомерВерсии, ВерсияСсылка.ПолноеНаименование, 
				ВерсияСсылка.Расширение, ВерсияСсылка.Размер,
				ВерсияСсылка.Зашифрован,
				Неопределено,
				ВерсияСсылка
			);
			
			ВерсияОбъект.ПутьКФайлу = НовыйПутьКФайлу;
			ВерсияОбъект.Том = СсылкаНаТом.Ссылка;
			
		КонецЕсли;
		
		ВерсияОбъект.СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен;
		
		ИспользоватьImageMagickДляРаспознаванияPDF = РаботаСФайламиВызовСервера.ПолучитьИспользоватьImageMagickДляРаспознаванияPDF();
		
		ПрограммаРаспознавания = РаботаСФайламиВызовСервера.ПрограммаРаспознавания();
		РасширениеПоддерживается = РаботаСФайламиКлиентСервер.ЭтотФайлМожноРаспознать(
			ВерсияОбъект.Расширение, ИспользоватьImageMagickДляРаспознаванияPDF, ПрограммаРаспознавания);
		
		Если РасширениеПоддерживается Тогда
			ИМОВладельца = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(ВладелецФайла));
			ВерсияОбъект.СтатусРаспознаванияТекста = РаботаСФайламиВызовСервера.СтатусРаспознаванияПоУмолчаниюДляФайловВладельца(
				ИМОВладельца);
		КонецЕсли;	
		
		ВерсияОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина); // чтобы прошла запись ранее подписанного объекта
		ВерсияОбъект.Записать();
		
		РаботаСФайламиВызовСервера.ЗаписатьОбращениеКВерсииФайла(ВерсияСсылка);
		РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
		
		Если УдалитьФайлИзПутиСохранения Тогда
			Файл.УстановитьТолькоЧтение(Ложь);
			УдалитьФайлы(ПутьСохранения);
		КонецЕсли;	
		
		ЗафиксироватьТранзакцию();
		Возврат Истина;
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецФункции

