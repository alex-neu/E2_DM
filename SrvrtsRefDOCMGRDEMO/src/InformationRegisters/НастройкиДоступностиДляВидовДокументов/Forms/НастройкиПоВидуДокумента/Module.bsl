
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ВидДокумента) Тогда 
		
		Если ТипЗнч(Параметры.ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда 
			ТипДокумента = Перечисления.ТипыОбъектов.ВходящиеДокументы;
		ИначеЕсли ТипЗнч(Параметры.ВидДокумента) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда 
			ТипДокумента = Перечисления.ТипыОбъектов.ИсходящиеДокументы;
		ИначеЕсли ТипЗнч(Параметры.ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда 
			ТипДокумента = Перечисления.ТипыОбъектов.ВнутренниеДокументы;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	НастройкиДоступностиПоСостоянию.Ссылка КАК НастройкаДоступностиПоСостоянию
			|ИЗ
			|	Справочник.НастройкиДоступностиПоСостоянию КАК НастройкиДоступностиПоСостоянию
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиДоступностиДляВидовДокументов КАК РегистрСведенийНастройкиДоступностиДляВидовДокументов
			|		ПО НастройкиДоступностиПоСостоянию.Ссылка = РегистрСведенийНастройкиДоступностиДляВидовДокументов.НастройкаДоступностиПоСостоянию
			|ГДЕ
			|	НЕ НастройкиДоступностиПоСостоянию.Ссылка.ПометкаУдаления
			|	И НастройкиДоступностиПоСостоянию.ТипДокумента = &ТипДокумента
			|	И РегистрСведенийНастройкиДоступностиДляВидовДокументов.НастройкаДоступностиПоСостоянию ЕСТЬ NULL 
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	РегистрСведенийНастройкиДоступностиДляВидовДокументов.НастройкаДоступностиПоСостоянию
			|ИЗ
			|	РегистрСведений.НастройкиДоступностиДляВидовДокументов КАК РегистрСведенийНастройкиДоступностиДляВидовДокументов
			|ГДЕ
			|	НЕ РегистрСведенийНастройкиДоступностиДляВидовДокументов.НастройкаДоступностиПоСостоянию.ПометкаУдаления
			|	И РегистрСведенийНастройкиДоступностиДляВидовДокументов.НастройкаДоступностиПоСостоянию.ТипДокумента = &ТипДокумента
			|	И РегистрСведенийНастройкиДоступностиДляВидовДокументов.ВидДокумента = &ВидДокумента";
			
		Запрос.Параметры.Вставить("ТипДокумента", ТипДокумента);
		Запрос.Параметры.Вставить("ВидДокумента", Параметры.ВидДокумента);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл 
			НоваяСтрока = СписокНастроек.Добавить();
			НоваяСтрока.НастройкаДоступностиПоСостоянию = Выборка.НастройкаДоступностиПоСостоянию;
			
			УчастникиДляСписка = "";
			Для Каждого Строка Из Выборка.НастройкаДоступностиПоСостоянию.ИспользоватьДля Цикл 
				УчастникиДляСписка = УчастникиДляСписка + Строка(Строка.Участник) + ", ";
			КонецЦикла;
			
			Если СтрДлина(УчастникиДляСписка) > 0 Тогда 
				УчастникиДляСписка = Лев(УчастникиДляСписка, СтрДлина(УчастникиДляСписка) - 2);
			КонецЕсли;
			
			НоваяСтрока.Участники = УчастникиДляСписка;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.СписокНастроек.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.НастройкаДоступностиПоСостоянию);
	
КонецПроцедуры
