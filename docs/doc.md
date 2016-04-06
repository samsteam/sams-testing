# Algoritmo en general

### Entrada
Cola de requerimientos. Un requerimiento consta de un id de proceso, un número de página y un modo (lectura, escritura, finalizar).

### Salida
Una imagen de la memoria a través del tiempo. Un arreglo de memorias vendría a ser, con ciertos datos sobre la página.

### Proceso
Cuando se atiende un requerimiento, se evalúa si la página está cargada en memoria. Si está, se llevarán a cabo ciertas actividades de actualización, ya veremos cuáles. Si no está, se genera un page fault.

Ante un page fault, se debe cargar la página en la memoria. Se evalúa si hay lugar en la memoria. Si hay lugar, se ubica la página en un marco libre. Si no, se debe seleccionar una página víctima. Esta elección está a cargo del algoritmo de reemplazo. Una vez elegida la víctima, se ubica la página solicitada en el marco correspondiente y se llevan a cabo las actividades de actualización.

##### ¿Hay lugar?
La respuesta depende de la **política de asignación**:

- si es **fija**, un proceso debe respetar la cantidad de marcos que se le asignó, por lo que se debe evaluar que no haya ocupado ya esa cantidad;
- si es **dinámica**, los marcos se ocupan bajo demanda, por lo que sólo se evalúa que la memoria no esté llena.

##### Elección de la víctima
Los algoritmos mantienen estructuras que conocen a las páginas que están en la memoria y que las ordenan según su proximidad a ser elegidas como víctima. Este proceso depende de la **política de reemplazo**:

- si es **local**, la página víctima debe pertenecer al mismo proceso que la del requerimiento, por lo que se observarán sólo aquellas páginas de la estructura cuyo proceso se corresponda con el del requerimiento;
- si es **global**, la página víctima puede ser cualquiera, por lo que se observará la estructura completa.

##### ¿Qué son las actividades de actualización?
Las que lleva a cabo cada algoritmo luego de atender un requerimiento.

# FIFO

### Elección de la víctima
La estructura que maneja es una cola de páginas común. Cuando hay que elegir una víctima, simplemente se desencola una página.

### Actividades de actualización
Cuando se genera un page fault y se agrega una página a la memoria, también se la agrega a la cola de víctimas.

# LRU

### Elección de la víctima
Idem FIFO.

### Actividades de actualización
- Cuando se genera un page fault y se agrega una página a la memoria, también se la agrega a la cola de víctimas.
- Cuando no se genera page fault, se reubica la página en cuestión dentro de la cola de víctimas: se la mueve al final, como si recién hubiera sido cargada.

# Óptimo

### Elección de la víctima
<!--La víctima será aquella que sea referenciada más lejos en el tiempo. O sea, se evalúan los instantes restantes para la próxima referencia de todas las páginas cargadas en memoria, y se elige como víctima la de mayor resultado.
-->
Uso una lista de páginas con su respectiva distancia de referencia, ordenadas por este valor. La víctima será siempre la primer página de la lista.

### Actividades de actualización
- Cuando se produce un page fault y se agrega una página a la memoria, se calcula la distancia de referencia y se la inserta ordenada en la lista.
- Cuando no se produce page fault, significa que la distancia de referencia conocida para esa página ya no es válida, por lo que se debe recalcular y reinsertar en la lista.

# Adicionales
Agregan lógica al momento de llevar a cabo ciertas actividades.

### Segunda chance
Se adiciona a cada página un bit de referencia.

##### Aplicabilidad
- FIFO
- LRU

##### Elección de la víctima
Se evalúa el bit de referencia de la víctima original elegida por el algoritmo. Si está en 1, se la envía al final de la cola, como si recién hubiera sido cargada. Si está en 0, se mantiene como víctima.

##### Actividades de actualización
- Cuando se produce un page fault y se agrega una página a la memoria, el bit de referencia de la misma se pone en 0.
- Cuando no se produce page fault, la página fue referenciada por lo que su bit de referencia se pone en 1.

### Descarga asincrónica
Se adiciona a cada página un bit de modificación. Se setean marcos de descarga asincrónica (DA).

##### Aplicabilidad
Todos.

##### Elección de la víctima
<!--Si sólo quedan marcos DA libres:
- se ubica a la nueva página en uno de ellos,
- se toma de la estructura de víctimas la página más próxima que se encuentre modificada,
- se pone el marco de esa página como DA.
-->
Si la víctima está modificada:

- se ubica a la nueva página en un marco de DA,
- se marca como DA el marco de la víctima.

##### Actividades de actualización
Cuando el modo de un requerimiento es *escritura*, se pone en 1 el bit de modificación de dicha página en memoria.