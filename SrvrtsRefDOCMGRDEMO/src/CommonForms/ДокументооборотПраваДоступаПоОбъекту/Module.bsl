// Форма принимает параметры:
//
//		ОбъектДоступа - ссылка - объект, права на который будут отображены на форме.
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗакрыватьПриЗакрытииВладельца = Истина;
	
	Если Пользователи.ЭтоПолноправныйПользователь(,, Ложь) Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;
	
	ОбъектДоступа = Параметры.ОбъектДоступа;
	ТипОбъектаДоступа = ТипЗнч(ОбъектДоступа);
	
	Заголовок = Заголовок + " (" + Строка(ОбъектДоступа) + ")";
	
	ТипВсеПапки = Метаданные.ОпределяемыеТипы.Папки.Тип;
	Элементы.ПраваДоступаУправлениеПравами.Видимость = ТипВсеПапки.СодержитТип(ТипОбъектаДоступа);
	
	Дескрипторы.Параметры.УстановитьЗначениеПараметра("ОбъектДоступа", ОбъектДоступа);
	
	Если ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.Файлы") Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.Обновить.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьТаблицуПрав();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСервер()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Протокол = Новый Массив;
	
	ТипОбъектаДоступа = ТипЗнч(ОбъектДоступа);
	ТипыСсылокМеханизмаДоступа =
		ДокументооборотПраваДоступаПовтИсп.ТипыСсылокИспользующихДоступПоДескрипторам();
	
	Если ТипыСсылокМеханизмаДоступа.Найти(ТипОбъектаДоступа) <> Неопределено Тогда
		
		// Определение дескриптора объекта заново
		ТаблицаДескрипторов = ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(ОбъектДоступа,, Протокол);
		
		Для Каждого СтрокаДескриптора Из ТаблицаДескрипторов Цикл
			
			// Немедленный расчет прав без обновления зависимых прав.
			Справочники.ДескрипторыДоступаОбъектов.РассчитатьПрава(СтрокаДескриптора.Дескриптор, Протокол);
			
			// Постановка в очередь для расчета прав зависимых объектов.
			Справочники.ДескрипторыДоступаОбъектов.ОбновитьПрава(СтрокаДескриптора.Дескриптор);
			
		КонецЦикла;
		
	Иначе
		
		МетаданныеОбъекта = ОбъектДоступа.Метаданные();
		ЭтоПроцесс = ОбщегоНазначения.ЭтоБизнесПроцесс(МетаданныеОбъекта);
		ЭтоЗадача  = ОбщегоНазначения.ЭтоЗадача(МетаданныеОбъекта);
		
		// Перезаполнение участников процесса
		Если ЭтоПроцесс Или ЭтоЗадача Тогда
			
			Процесс = ?(ЭтоПроцесс, ОбъектДоступа, 
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектДоступа, "БизнесПроцесс"));
			
			ПроцессОбъект = Процесс.ПолучитьОбъект();
			ТаблицаНабора = РегистрыСведений.УчастникиПроцессов.СоздатьНаборЗаписей().ВыгрузитьКолонки();
			
			Участники = ПраваДоступаНаБизнесПроцессы.ПолучитьТаблицуУчастниковПроцесса(ПроцессОбъект);
			Для Каждого Участник Из Участники Цикл
				Запись = ТаблицаНабора.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, Участник);
				Запись.Процесс = Процесс;
			КонецЦикла;
			
			СоставРГ = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(Процесс);
			Для Каждого СтрокаРГ Из СоставРГ Цикл
				Запись = ТаблицаНабора.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, СтрокаРГ);
				Запись.Процесс = Процесс;
			КонецЦикла;
			
			ТаблицаНабора.Свернуть("Процесс, Участник");
			РегистрыСведений.УчастникиПроцессов.ЗаписатьНаборПоПроцессу(Процесс, ТаблицаНабора);
			
			ЗаписьПротокола =  Новый Структура("Элемент, Описание",
				"УчастникиПроцесса", НСтр("ru = 'Участники процесса'"));
			Протокол.Добавить(ЗаписьПротокола);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь(,, Ложь) Тогда
		Элементы.СтраницаПротоколРасчетаПрав.Видимость = Истина;
	КонецЕсли;
	
	ПротоколРасчетаПрав.Очистить();
	
	Для Каждого Эл Из Протокол Цикл
		
		ТипЭлемента = ТипЗнч(Эл);
		Строка = ПротоколРасчетаПрав.Добавить();
		Если ТипЭлемента = Тип("Строка") Тогда
			Строка.Описание = Эл;
		ИначеЕсли ТипЭлемента = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(Строка, Эл);
		Иначе
			Строка.Описание = Строка(Эл) + " (" + Строка(ТипЗнч(Эл)) + ")";
			Строка.Элемент = Эл;
		КонецЕсли;	
		
	КонецЦикла;
	
	// Добавление руководителей, делегатов и неограниченных прав в протокол расчета
	Если Константы.ДобавлятьРуководителямДоступПодчиненных.Получить() Тогда
		Строка = ПротоколРасчетаПрав.Добавить();
		Строка.Элемент = "Руководители";
		Строка.Описание = НСтр("ru = 'Руководители'");
	КонецЕсли;
	
	Строка = ПротоколРасчетаПрав.Добавить();
	Строка.Элемент = "Делегаты";
	Строка.Описание = НСтр("ru = 'Делегаты'");
	
	Строка = ПротоколРасчетаПрав.Добавить();
	Строка.Элемент = "НеограниченныеПраваНаТаблицу";
	Строка.Описание = НСтр("ru = 'Неограниченные права'");
	
	ЗаполнитьТаблицуПрав();
	
КонецПроцедуры

&НаСервере	
Процедура ЗаполнитьТаблицуПрав()
	
	ТаблицаПрав = ДокументооборотПраваДоступа.ПолучитьТаблицуПравДляОтображенияВИнтерфейсе(ОбъектДоступа);
	ПраваДоступа.Загрузить(ТаблицаПрав);
	
КонецПроцедуры

&НаКлиенте
Процедура ПротоколРасчетаПравВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ПротоколРасчетаПрав.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТипОбъектаДоступа = ТипЗнч(ОбъектДоступа);
	ТипЭлементаПротокола = ТипЗнч(ТекущиеДанные.Элемент);
	
	Если ТекущиеДанные.Элемент = "Руководители" Тогда
		
		ОткрытьФорму("Справочник.СтруктураПредприятия.ФормаСписка");
		
	ИначеЕсли ТекущиеДанные.Элемент = "Делегаты" Тогда
		
		ОткрытьФорму("Справочник.ДелегированиеПрав.ФормаСписка");
		
	ИначеЕсли ТекущиеДанные.Элемент = "ПолитикиДоступа" Тогда
		
		ОткрытьФорму("Обработка.ПолитикиДоступа.Форма");
		
	ИначеЕсли ТекущиеДанные.Элемент = "РабочаяГруппа" Тогда
		
		ПараметрыФормы = Новый Структура("ВладелецРабочейГруппы", ОбъектДоступа);
		ОткрытьФорму("РегистрСведений.РабочиеГруппы.Форма.РабочаяГруппаОбъекта", ПараметрыФормы, ЭтаФорма);
		
	ИначеЕсли ТекущиеДанные.Элемент = "НеограниченныеПраваНаТаблицу" Тогда
		
		// Открытие отчета по группам с неограниченными правами
		ПараметрыОтчета = Новый Структура("ОбъектДанных", ОбъектДоступа);
		ОткрытьФорму("Отчет.НеограниченныеПрава.Форма.ФормаОтчета", ПараметрыОтчета);
		
	ИначеЕсли ТекущиеДанные.Элемент = "НастройкиПравПапки" Тогда
		
		// Открытие настроек прав папки
		Папка = Неопределено;
		
		Если ТипВсеПапки.СодержитТип(ТипОбъектаДоступа) Тогда
			Папка = ОбъектДоступа;
		ИначеЕсли ТипОбъектаДоступа = Тип("СправочникСсылка.Файлы") Тогда
			Папка = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
				ОбъектДоступа, "ВладелецФайла");
		Иначе
			Папка = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
				ОбъектДоступа, "Папка");
		КонецЕсли;
			
		Если ЗначениеЗаполнено(Папка) Тогда
			ПараметрыФормы = Новый Структура("СсылкаНаОбъект", Папка);
			ОткрытьФорму("ОбщаяФорма.НастройкиПравПапок", ПараметрыФормы,, Папка);
		КонецЕсли;
		
	ИначеЕсли ТекущиеДанные.Элемент = "УчастникиПроцесса" Тогда
		
		Если ТипОбъектаДоступа = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
			Процесс = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
				ОбъектДоступа, "БизнесПроцесс");
		Иначе
			Процесс = ОбъектДоступа;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура("Процесс", Процесс);
		ОткрытьФорму("РегистрСведений.УчастникиПроцессов.Форма.УчастникиПроцесса", ПараметрыФормы);
		
	// Обработка строки "ОбъектДоступа"
	ИначеЕсли ТекущиеДанные.Элемент = "ОбъектДоступа" Тогда
		
		ПоказатьЗначение(, ОбъектДоступа);
		
	// Обработка строк вида "Права_Документ"
	ИначеЕсли ТипЭлементаПротокола = Тип("Строка")
		И Лев(ТекущиеДанные.Элемент, 6) = "Права_" Тогда
		
		ИмяРеквизита = СтрЗаменить(ТекущиеДанные.Элемент, "Права_", "");
		ЗначениеРеквизита = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			ОбъектДоступа, ИмяРеквизита);
		ПоказатьЗначение(, ЗначениеРеквизита);
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Элемент) Тогда
		
		Если ТипЭлементаПротокола = Тип("Строка") Тогда
			ПоказатьПредупреждение(, ТекущиеДанные.Элемент);
		Иначе
			ПоказатьЗначение(, ТекущиеДанные.Элемент);
		КонецЕсли;
			
	Иначе
		
		ПоказатьПредупреждение(, ТекущиеДанные.Описание);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ПраваДоступа.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(,ТекущиеДанные.Пользователь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДескрипторыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элементы.Дескрипторы.ТекущиеДанные.Дескриптор);
	
КонецПроцедуры
