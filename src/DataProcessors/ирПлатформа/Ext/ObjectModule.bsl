Функция СтатусКлавиатурыВК() Экспорт // PushA
	
	ВК = ПоместитьВоВременноеХранилище(ПолучитьМакет("StateKeyboard"));
	Если Не ПодключитьВнешнююКомпоненту(ВК, "KeyboardVK") Тогда //zip архив - StateKeyboard.zip 
		Возврат Неопределено;
	КонецЕсли;
	
	KeyboardVK = Новый("AddIn.KeyboardVK.AddInNativeExtension");
	
	Если KeyboardVK <> Неопределено И KeyboardVK.Version() <> "1.0" Тогда 
		KeyboardVK = СтатусКлавиатурыВК();
	КонецЕсли;
	
	Возврат KeyboardVK;
	
	//KeyboardVK.GetKeyState(<Код Клавиши>)

КонецФункции