set(CPU_FLAGS -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16)
set(COMMON_FLAGS 
    -MP -MD -mthumb -mabi=aapcs -Wall -g3 -ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin --short-enums -fno-exceptions
    ${CPU_FLAGS}
)
set(LINK_OPTIONS ${CPU_FLAGS} -L${NRF5_SDK_PATH}/modules/nrfx/mdk -Wl,--print-memory-usage,--gc-sections --specs=nano.specs -lc -lnosys -lm)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)