/* One-shot VPI vector deposit. No force, callback, or DUT behavior replacement. */
#include <stdlib.h>
#include "vpi_user.h"

static PLI_INT32 deposit4(PLI_BYTE8 *unused) {
    (void)unused;
    vpiHandle call = vpi_handle(vpiSysTfCall, 0);
    vpiHandle args = vpi_iterate(vpiArgument, call);
    vpiHandle target = vpi_scan(args);
    vpiHandle source = vpi_scan(args);
    if (!target || !source || vpi_scan(args) ||
        vpi_get(vpiSize, target) != vpi_get(vpiSize, source)) {
        vpi_printf("ERROR: $fourstate_deposit requires equal-width target and value\n");
        vpi_control(vpiFinish, 1);
        return 0;
    }
    s_vpi_value value;
    value.format = vpiVectorVal;
    vpi_get_value(source, &value);
    vpi_put_value(target, &value, 0, vpiNoDelay);
    return 0;
}

static void register_deposit4(void) {
    s_vpi_systf_data task = {0};
    task.type = vpiSysTask;
    task.tfname = "$fourstate_deposit";
    task.calltf = deposit4;
    vpi_register_systf(&task);
}

void (*vlog_startup_routines[])(void) = {register_deposit4, 0};
