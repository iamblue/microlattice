#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "FreeRTOS.h"
#include "task.h"
#include "net_init.h"
#include "network_init.h"
#ifdef MTK_HOMEKIT_ENABLE
#include "homekit_init.h"
#endif

#ifdef MTK_JR_ENABLE
#include "jerry.h"
#endif

// jerry_api_value_t* g_callbackvalue = NULL;

void js_init() {
  // remember to add `var global={};`
  char script [] = <%- JS_CODE %>;

  jerry_init (JERRY_FLAG_EMPTY);
  jerry_api_value_t eval_ret;


  /* <%= ML_INIT %> */

  jerry_api_eval (script, strlen (script), false, false, &eval_ret);
  jerry_api_release_value (&eval_ret);
  // jerry_cleanup ();
  vTaskDelete(NULL);
}

void httpclient_test(void) {
  char script [] = "global.__wifiStatus.emit('connect', true);";
  jerry_api_value_t eval_ret;
  jerry_api_eval (script, strlen (script), false, false, &eval_ret);
  jerry_api_release_value (&eval_ret);
  vTaskDelete(NULL);
}

void httpclient_task(void *parameter) {
  httpclient_test();
  for (;;) {
      ;
  }
}

void httpclient_callback(const struct netif *netif) {
  xTaskCreate(httpclient_task, "HttpclientTestTask", 10048, NULL, 1, NULL);
}

/**
  * @brief  Main program
  * @param  None
  * @retval None
  */
int main(void)
{
    system_init();
    wifi_register_ip_ready_callback(httpclient_callback);
    network_init();
#ifdef MTK_HOMEKIT_ENABLE
    homekit_init();
#endif
    xTaskCreate(js_init,"js_init", 14096, NULL, 2, NULL);
    vTaskStartScheduler();
    while (1) {
    }
    return 0;
}

