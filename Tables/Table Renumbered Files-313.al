OBJECT table 20457 Sky SMS Messages
{
  OBJECT-PROPERTIES
  {
    Date=02/10/21;
    Time=[ 4:55:30 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;originator_id       ;GUID           }
    { 2   ;   ;msg_id              ;BigInteger     }
    { 3   ;   ;msg_product_id      ;Integer        }
    { 4   ;   ;msg_provider_code   ;Code50         }
    { 5   ;   ;msg_charge          ;Code50         }
    { 6   ;   ;msg_status_code     ;Integer        }
    { 7   ;   ;msg_status_description;Text250      }
    { 8   ;   ;msg_status_date     ;DateTime       }
    { 9   ;   ;sender              ;Text50         }
    { 10  ;   ;receiver            ;Code50         }
    { 11  ;   ;msg                 ;Text250        }
    { 12  ;   ;msg_type            ;Code5          }
    { 13  ;   ;msg_source_reference;Code50         }
    { 14  ;   ;msg_destination_reference;Code50    }
    { 15  ;   ;msg_xml_data        ;Code250        }
    { 16  ;   ;msg_category        ;Code30         }
    { 17  ;   ;msg_priority        ;Integer        }
    { 18  ;   ;msg_send_count      ;Integer        }
    { 19  ;   ;schedule_msg        ;Text10         }
    { 20  ;   ;date_scheduled      ;DateTime       }
    { 21  ;   ;msg_send_integrity_hash;Code100     }
    { 22  ;   ;msg_response_date   ;DateTime       }
    { 23  ;   ;msg_response_xml_data;Text250       }
    { 24  ;   ;msg_response_integrity_hash;Code100 }
    { 25  ;   ;transaction_date    ;DateTime       }
    { 26  ;   ;date_created        ;DateTime       }
    { 27  ;   ;SMS Date            ;Date           }
    { 28  ;   ;Account To Charge   ;Code20         }
    { 29  ;   ;Posted              ;Boolean        }
    { 101 ;   ;transaction_id      ;Integer       ;AutoIncrement=Yes }
    { 103 ;   ;server_id           ;BigInteger     }
    { 107 ;   ;msg_charge_applied  ;Code50         }
    { 114 ;   ;msg_format          ;Code50         }
    { 116 ;   ;msg_command         ;Text100        }
    { 117 ;   ;msg_sensitivity     ;Code20         }
    { 127 ;   ;msg_response_description;Text250    }
    { 301 ;   ;msg_result_description;Text250      }
    { 302 ;   ;msg_result_xml_data ;Text250        }
    { 303 ;   ;msg_result_date     ;DateTime       }
    { 304 ;   ;msg_result_integrity_hash;Text250   }
    { 305 ;   ;msg_result_submit_count;Integer     }
    { 306 ;   ;msg_result_submit_status;Code20     }
    { 307 ;   ;msg_result_submit_description;Text250 }
    { 308 ;   ;msg_result_submit_date;DateTime     }
    { 309 ;   ;msg_general_flag    ;Code100        }
    { 310 ;   ;sender_type         ;Text30         }
    { 311 ;   ;receiver_type       ;Text30         }
    { 312 ;   ;Charge Member       ;Boolean        }
    { 313 ;   ;Finalized           ;Boolean        }
    { 314 ;   ;Insufficient Balance;Boolean        }
    { 316 ;   ;msg_request_application;Text50      }
    { 317 ;   ;msg_request_correlation_id;Text50   }
    { 318 ;   ;msg_source_application;Text50       }
    { 319 ;   ;msg_response        ;Text30         }
    { 320 ;   ;msg_response_code   ;Integer        }
    { 321 ;   ;msg_result          ;Text50         }
    { 322 ;   ;msg_result_code     ;Integer        }
    { 323 ;   ;msg_mode            ;Text30         }
  }
  KEYS
  {
    {    ;originator_id                           ;Clustered=Yes }
    {    ;date_created                             }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

