# MQTT 代理服務

在 [Postman](https://github.com/eastmoon/infra-postman) 的專案中，可以瞭解藉由 Postman 撰寫 WebAPI 的測試腳本與保存測試項目檔案，來達到版本控制與自動化測試；而在 [Client-Server 架構](https://zh.wikipedia.org/zh-tw/%E4%B8%BB%E5%BE%9E%E5%BC%8F%E6%9E%B6%E6%A7%8B)中，Client 可以主動透過 WebAPI 與 Server 溝通，但這機制無法接受 Server 主動反饋；倘若要接收 Server 的主動通知，則必須選擇 [TCP](https://zh.wikipedia.org/zh-tw/TCP/IP%E5%8D%8F%E8%AE%AE%E6%97%8F) 通訊協議中的雙向通訊機制，在這機制中，Client 需利用 [Socket.IO](https://zh.wikipedia.org/zh-tw/Socket.IO) 或 [WebSocket](https://zh.wikipedia.org/zh-tw/WebSocket) 來建立對主機的訊息監聽，而 Server 可利用 Socket 或 Message Queue 做到訊息接收與發送，至於這兩者差異請參考文獻。

在實務上，由於 Message Queue 的通訊機制與設計，除了前述的 Client-Server 架構外，更可運用於 [Microservice](https://docs.microsoft.com/zh-tw/dotnet/architecture/microservices/multi-container-microservice-net-applications/rabbitmq-event-bus-development-test-environment) 架構與 [IoT](https://medium.com/opensanca/60dfb7d8ac52) 相關設計；其技術演進更從早期的 Message Queue 推展至 MQTT ( Message Queuing Telemetry Transport ) 技術標準。

對此，若基於 E2E 測試，在假定模擬 Client 端或 IoT Device 端，則會需要完整對 Server 端的對外接口的測試項目，而這除了 WebAPI 外，使用 MQTT 機制的通訊介面與資料傳輸也有必要驗證，以確保軟體通訊整體的檢測覆蓋率，並同時檢驗軟體的執行正確性與流程測試；但考量主動通訊機制的檢測程序，其設計原則本身與 WebAPI 並不相同，亦無法單純運用 Postman 進行直接通訊，對此便需要設計一個代理服務，將對 MQTT 的通訊資訊與內容藉由 WebAPI 介面設計，以便運用 Postman 保留測試項目。

代理服務應具備以下用途：

+ 可透過指令 ```curl``` 或服務檢測工具 Postman 對 Agent 系統收發送訊息
+ 可發送 Published 訊息給目標 MQTT 系統
    - 使用發送 ( POST ) 為其方法
+ 可接受 Subscribe 訊息以便偵聽 MQTT 系統發出的訊息
    - 依據設計可分為註冊 ( PUT )、取得 ( GET ) 兩個方法
    - 第一方案是使用取得，直接等候一段固定時間，若此期間無發送則不會收到任何訊息
    - 第二方案是使用註冊啟動偵聽，並於時間內發送取得，若中間有發送則會取回資訊，反之則無法取得內容
+ 可藉由流程腳本驗收流程正確性

代理服務應對以下兩個 MQTT 系統：

+ [Mosquitto](https://mosquitto.org/)
+ [RabbitMQ](https://www.rabbitmq.com/)

代理服務使用系統：

+ Server : Nginx + CGI
+ CGI : Perl + Shell

## 指令

+ 啟動 Mosquitto 開發環境

```
mosquitto.bat dev
```
> 此指令用於 Windows 作業系統，並透過 Docker Compose 啟動一個 mosquitto 服務與 nginx + mosquitto-client 服務。

+ 測試 Mosquitto 腳本

```
mosquitto.bat test
```
> 此指令用於 Windows 作業系統，並透過 Docker Compose 啟動一個 mosquitto 服務與 nginx + mosquitto-client 服務。

## 文獻

+ [Socket v.s Message Queue](https://github.com/eastmoon/research-software-theory#distribution--network)
    - [Message queues vs sockets](https://stackoverflow.com/questions/10668028)
+ End-to-End 測試
    - [What is end-to-end testing?](https://circleci.com/blog/what-is-end-to-end-testing/)
    - [一次搞懂單元測試、整合測試、端對端測試之間的差異](https://blog.miniasp.com/post/2019/02/18/Unit-testing-Integration-testing-e2e-testing)
+ mosquitto
    - 文獻
        + [mosquitto - Docker hub](https://hub.docker.com/_/eclipse-mosquitto)
        + [mosquitto_pub](https://mosquitto.org/man/mosquitto_pub-1.html)
        + [mosquitto_sub](https://mosquitto.org/man/mosquitto_sub-1.html)
    + 設計參考
        + [FIWARE - IoT Over MQTT](https://fiware-tutorials.readthedocs.io/en/stable/iot-over-mqtt/)
        + [Shelly - MQTT API](https://shelly-api-docs.shelly.cloud/gen2/ComponentsAndServices/Mqtt/)
        + [MQTT in curl](https://curl.se/docs/mqtt.html)
+ rabbitmq
    + [rabbitmq - Docker hub](https://hub.docker.com/_/rabbitmq)
