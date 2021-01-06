
// См. Справочники.ПрофилиГруппДоступа.ПоставляемыеПрофили.
Функция ОписаниеПоставляемыхПрофилей() Экспорт
	
	Возврат Справочники.ПрофилиГруппДоступа.ОписаниеПоставляемыхПрофилей();
	
КонецФункции
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Управление доступом".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. УправлениеДоступомСлужебный.СвойстваВидовДоступа.
Функция СвойстваВидовДоступа() Экспорт
	
	Возврат УправлениеДоступомПовтИспДокументооборот.СвойстваВидовДоступа();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Функция ОписаниеКлючаЗаписи(ТипИлиПолноеИмя) Экспорт
	
	ОписаниеКлюча = Новый Структура("МассивПолей, СтрокаПолей", Новый Массив, "");
	
	Если ТипЗнч(ТипИлиПолноеИмя) = Тип("Тип") Тогда
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипИлиПолноеИмя);
	Иначе
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ТипИлиПолноеИмя);
	КонецЕсли;
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
	
	Для каждого Колонка Из Менеджер.СоздатьНаборЗаписей().Выгрузить().Колонки Цикл
		
		Если ОбъектМетаданных.Ресурсы.Найти(Колонка.Имя) = Неопределено
		   И ОбъектМетаданных.Реквизиты.Найти(Колонка.Имя) = Неопределено Тогда
			// Если поля нет в ресурсах и реквизитах, значит это поле - измерение.
			ОписаниеКлюча.МассивПолей.Добавить(Колонка.Имя);
			ОписаниеКлюча.СтрокаПолей = ОписаниеКлюча.СтрокаПолей + Колонка.Имя + ",";
		КонецЕсли;
	КонецЦикла;
	
	ОписаниеКлюча.СтрокаПолей = Лев(ОписаниеКлюча.СтрокаПолей, СтрДлина(ОписаниеКлюча.СтрокаПолей)-1);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ОписаниеКлюча);
	
КонецФункции

// Только для внутреннего использования.
Функция ТипыПоляТаблицы(Таблица, ГруппаПолей, Поле) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(Таблица);
	
	ТипыПоля = Новый Соответствие;
	
	Для каждого Тип Из ОбъектМетаданных[ГруппаПолей][Поле].Тип.Типы() Цикл
		ТипыПоля.Вставить(Тип, Истина);
	КонецЦикла;
	
	Возврат ТипыПоля;
	
КонецФункции

// Возвращает типы объектов и ссылок в указанных подписках на события.
// 
// Параметры:
//  ИменаПодписок - Строка - многострочная строка, содержащая
//                  строки начала имени подписки.
//
Функция ТипыОбъектовВПодпискахНаСобытия(ИменаПодписок) Экспорт
	
	ТипыОбъектов = Новый Соответствие;
	
	Для каждого Подписка Из Метаданные.ПодпискиНаСобытия Цикл
		
		Для НомерСтроки = 1 По СтрЧислоСтрок(ИменаПодписок) Цикл
			
			НачалоИмени = СтрПолучитьСтроку(ИменаПодписок, НомерСтроки);
			Если ВРег(Лев(Подписка.Имя, СтрДлина(НачалоИмени))) = ВРег(НачалоИмени) Тогда
				
				Для каждого Тип Из Подписка.Источник.Типы() Цикл
					ТипыОбъектов.Вставить(Тип, Истина);
				КонецЦикла;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(ТипыОбъектов);
	
КонецФункции

Функция РазделенныеДанныеНедоступны() Экспорт
	
	Возврат Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
КонецФункции

Функция ОписаниеПредопределенногоИдентификатораОбъектаМетаданных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Имена = УправлениеДоступомСлужебныйПовтИсп.ИменаПредопределенныхЭлементовСправочника(
		"ИдентификаторыОбъектовМетаданных");
	
	Имя = СтрЗаменить(ПолноеИмяОбъектаМетаданных, ".", "");
	
	Если Имена.Найти(Имя) <> Неопределено Тогда
		Возврат "ИдентификаторыОбъектовМетаданных." + Имя;
	КонецЕсли;
	
	Имена = УправлениеДоступомСлужебныйПовтИсп.ИменаПредопределенныхЭлементовСправочника(
		"ИдентификаторыОбъектовРасширений");
	
	Если Имена.Найти(Имя) <> Неопределено Тогда
		Возврат "ИдентификаторыОбъектовРасширений." + Имя;
	КонецЕсли;
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	Если ОбъектМетаданных = Неопределено Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить имя предопределенного идентификатора объекта метаданных
			           |так как не существует указанный объект метаданных:
			           |""%1"".'"),
			ПолноеИмяОбъектаМетаданных);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ОбъектМетаданных.РасширениеКонфигурации() = Неопределено Тогда
		Возврат "ИдентификаторыОбъектовМетаданных." + Имя;
	КонецЕсли;
	
	Возврат "ИдентификаторыОбъектовРасширений." + Имя;
	
КонецФункции

Функция ИменаПредопределенныхЭлементовСправочника(ИмяСправочника) Экспорт
	
	Возврат Метаданные.Справочники[ИмяСправочника].ПолучитьИменаПредопределенных();
	
КонецФункции

#КонецОбласти
