module test ();

typedef enum {RED, GREEN, YELLOW} traffic_signal;

traffic_signal light;

function void sv_GreenLight ();
begin
	light = GREEN;
end
endfunction

function void sv_YellowLight ();
begin
	light = YELLOW;
end
endfunction

function void sv_RedLight ();
begin
	light = RED;
end
endfunction

task sv_WaitForRed ();
begin
	#10;
end
endtask
// экспорт для внешней функции
export "DPI-C" function sv_YellowLight; 
export "DPI-C" function sv_RedLight;
export "DPI-C" task sv_WaitForRed;
// импорт для вызова внешней функции
import "DPI-C" context task c_CarWaiting (); 

initial
begin
	#10 sv_GreenLight; // зелёный свет
	#10 c_CarWaiting;  // внешняя функция
	#10 sv_GreenLight; // зелёный свет
	#10;
end

endmodule
