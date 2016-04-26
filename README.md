# Microlattice.js

Microlattice.js® is a JavaScript runtime framework built on Jerryscript. Jerryscript is the Lightweight JavaScript engine for Internet of Things. Microlattice.js uses an event-driven, non-blocking I/O model ( base on FreeRTOS Native api, without libuv )that makes it lightweight and efficient.

## Feature
[English]
* Platform for IoT device (especially: wifi + MCU) with javascript.
* Microlattice.js is adopting the similar coding style used in javascript community providing high performance like C.
* Everything you need like tools, modules, and engine core are modular designed.
* Providing standards for resolving the following issues you may encounter while developing embedded board:
  * Different MCU build tools.
  * Diverse in debug/download code.
  * License: dis-contribute limitation.
  * No common sharing project standard.
  * Existing JS total solution is not light-weighted enough, providing low performance comparing to C.
  * FreeRTOS does not have file system design.

[中文]
* 真正為 IoT device 所設計的 IoT 版 Node.js.
* 針對 Javascript community 所熟悉的 coding style 追求接近 C 的效能
* 每一個細節包含 tool, module, engine core 都是可以拆分重組
* 提供標準解決以下開發 embedded board 常見問題:
  * MCU build tool 環境各家很不一致
  * Debug/ Download code 各家皆不一樣
  * LICENSE 問題：大部份廠商 SDK 皆有 dis-contribute 規範
  * 沒有共同的 sharing project 標準
  * 現成的 Js total solution 不夠輕量，不符合效能接近 C
  * FreeRTOS 設計，沒有 filesystem 設計 ... 等等

## Microlattice command line

### Usage

* npm install ml-cli -g

* Initialize microlattice project

``` bash
ml create
```

* [TBD] donwload code to your device

```
ml burn
```

* [TBD] debugger ( use openOCD and GDB )

```
ml debugger
```

## Support chip list

* MT7687 (cm4 + wifi )

In MT7687 use case, please visit the [ml-mt7687-config](https://github.com/iamblue/ml-mt7687-config) on Github.

## About Jerryscript

If you want to know about JerryScript, you can visit the [Jerryscript](https://github.com/Samsung/jerryscript) project on github.

### Reference Slide


### License

Microlattice.js is Open Source software under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Complete license and copyright information can be found within the code.

> Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
