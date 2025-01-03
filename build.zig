const std = @import("std");

const log = std.log.scoped(.spirv_tools);

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const spirv_headers = b.dependency("spirv_headers", .{});

    const lib = b.addStaticLibrary(.{
        .name = "spirv-opt",
        .target = target,
        .optimize = optimize,
    });

    const tag = target.result.os.tag;

    if (tag == .windows) {
        lib.root_module.addCMacro("SPIRV_WINDOWS", "");
    } else if (tag == .linux) {
        lib.root_module.addCMacro("SPIRV_LINUX", "");
    } else if (tag == .macos) {
        lib.root_module.addCMacro("SPIRV_MAC", "");
    } else if (tag == .ios) {
        lib.root_module.addCMacro("SPIRV_IOS", "");
    } else if (tag == .tvos) {
        lib.root_module.addCMacro("SPIRV_TVOS", "");
    } else if (tag == .freebsd) {
        lib.root_module.addCMacro("SPIRV_FREEBSD", "");
    } else if (tag == .openbsd) {
        lib.root_module.addCMacro("SPIRV_OPENBSD", "");
    } else if (tag == .fuchsia) {
        lib.root_module.addCMacro("SPIRV_FUCHSIA", "");
    } else {
        log.err("Incompatible target platform.", .{});
        std.process.exit(1);
    }

    if (target.result.abi == .msvc) {
        lib.linkLibC();
    } else {
        lib.linkLibCpp();
    }

    lib.addCSourceFiles(.{ .files = sources, .flags = &.{"-std=c++17"} });
    lib.addIncludePath(b.path("."));
    lib.addIncludePath(b.path("include"));
    lib.addIncludePath(b.path("include-generated"));
    lib.addIncludePath(spirv_headers.path("include"));
    lib.addIncludePath(spirv_headers.path("include/spirv/unified1"));
    lib.installHeadersDirectory(b.path("include/spirv-tools"), "spirv-tools", .{});
    b.installArtifact(lib);
}

const sources = &[_][]const u8{
    "source/assembly_grammar.cpp",
    "source/binary.cpp",
    "source/diagnostic.cpp",
    "source/disassemble.cpp",
    "source/enum_string_mapping.cpp",
    "source/extensions.cpp",
    "source/ext_inst.cpp",
    "source/libspirv.cpp",
    "source/name_mapper.cpp",
    "source/opcode.cpp",
    "source/operand.cpp",
    "source/parsed_operand.cpp",
    "source/pch_source.cpp",
    "source/print.cpp",
    "source/software_version.cpp",
    "source/spirv_endian.cpp",
    "source/spirv_fuzzer_options.cpp",
    "source/spirv_optimizer_options.cpp",
    "source/spirv_reducer_options.cpp",
    "source/spirv_target_env.cpp",
    "source/spirv_validator_options.cpp",
    "source/table.cpp",
    "source/text.cpp",
    "source/text_handler.cpp",

    "source/opt/aggressive_dead_code_elim_pass.cpp",
    "source/opt/amd_ext_to_khr.cpp",
    "source/opt/analyze_live_input_pass.cpp",
    "source/opt/basic_block.cpp",
    "source/opt/block_merge_pass.cpp",
    "source/opt/block_merge_util.cpp",
    "source/opt/build_module.cpp",
    "source/opt/ccp_pass.cpp",
    "source/opt/cfg_cleanup_pass.cpp",
    "source/opt/cfg.cpp",
    "source/opt/code_sink.cpp",
    "source/opt/combine_access_chains.cpp",
    "source/opt/compact_ids_pass.cpp",
    "source/opt/composite.cpp",
    "source/opt/constants.cpp",
    "source/opt/const_folding_rules.cpp",
    "source/opt/control_dependence.cpp",
    "source/opt/convert_to_half_pass.cpp",
    "source/opt/convert_to_sampled_image_pass.cpp",
    "source/opt/copy_prop_arrays.cpp",
    "source/opt/dataflow.cpp",
    "source/opt/dead_branch_elim_pass.cpp",
    "source/opt/dead_insert_elim_pass.cpp",
    "source/opt/dead_variable_elimination.cpp",
    "source/opt/debug_info_manager.cpp",
    "source/opt/decoration_manager.cpp",
    "source/opt/def_use_manager.cpp",
    "source/opt/desc_sroa.cpp",
    "source/opt/desc_sroa_util.cpp",
    "source/opt/dominator_analysis.cpp",
    "source/opt/dominator_tree.cpp",
    "source/opt/eliminate_dead_constant_pass.cpp",
    "source/opt/eliminate_dead_functions_pass.cpp",
    "source/opt/eliminate_dead_functions_util.cpp",
    "source/opt/eliminate_dead_io_components_pass.cpp",
    "source/opt/eliminate_dead_members_pass.cpp",
    "source/opt/eliminate_dead_output_stores_pass.cpp",
    "source/opt/feature_manager.cpp",
    "source/opt/fix_func_call_arguments.cpp",
    "source/opt/fix_storage_class.cpp",
    "source/opt/flatten_decoration_pass.cpp",
    "source/opt/fold.cpp",
    "source/opt/folding_rules.cpp",
    "source/opt/fold_spec_constant_op_and_composite_pass.cpp",
    "source/opt/freeze_spec_constant_value_pass.cpp",
    "source/opt/function.cpp",
    "source/opt/graphics_robust_access_pass.cpp",
    "source/opt/if_conversion.cpp",
    "source/opt/inline_exhaustive_pass.cpp",
    "source/opt/inline_opaque_pass.cpp",
    "source/opt/inline_pass.cpp",
    "source/opt/inst_bindless_check_pass.cpp",
    "source/opt/inst_buff_addr_check_pass.cpp",
    "source/opt/inst_debug_printf_pass.cpp",
    "source/opt/instruction.cpp",
    "source/opt/instruction_list.cpp",
    "source/opt/instrument_pass.cpp",
    "source/opt/interface_var_sroa.cpp",
    "source/opt/interp_fixup_pass.cpp",
    "source/opt/invocation_interlock_placement_pass.cpp",
    "source/opt/ir_context.cpp",
    "source/opt/ir_loader.cpp",
    "source/opt/licm_pass.cpp",
    "source/opt/liveness.cpp",
    "source/opt/local_access_chain_convert_pass.cpp",
    "source/opt/local_redundancy_elimination.cpp",
    "source/opt/local_single_block_elim_pass.cpp",
    "source/opt/local_single_store_elim_pass.cpp",
    "source/opt/loop_dependence.cpp",
    "source/opt/loop_dependence_helpers.cpp",
    "source/opt/loop_descriptor.cpp",
    "source/opt/loop_fission.cpp",
    "source/opt/loop_fusion.cpp",
    "source/opt/loop_fusion_pass.cpp",
    "source/opt/loop_peeling.cpp",
    "source/opt/loop_unroller.cpp",
    "source/opt/loop_unswitch_pass.cpp",
    "source/opt/loop_utils.cpp",
    "source/opt/mem_pass.cpp",
    "source/opt/merge_return_pass.cpp",
    "source/opt/module.cpp",
    "source/opt/optimizer.cpp",
    "source/opt/pass.cpp",
    "source/opt/pass_manager.cpp",
    "source/opt/pch_source_opt.cpp",
    "source/opt/private_to_local_pass.cpp",
    "source/opt/propagator.cpp",
    "source/opt/reduce_load_size.cpp",
    "source/opt/redundancy_elimination.cpp",
    "source/opt/register_pressure.cpp",
    "source/opt/relax_float_ops_pass.cpp",
    "source/opt/remove_dontinline_pass.cpp",
    "source/opt/remove_duplicates_pass.cpp",
    "source/opt/remove_unused_interface_variables_pass.cpp",
    "source/opt/replace_desc_array_access_using_var_index.cpp",
    "source/opt/replace_invalid_opc.cpp",
    "source/opt/scalar_analysis.cpp",
    "source/opt/scalar_analysis_simplification.cpp",
    "source/opt/scalar_replacement_pass.cpp",
    "source/opt/set_spec_constant_default_value_pass.cpp",
    "source/opt/simplification_pass.cpp",
    "source/opt/spread_volatile_semantics.cpp",
    "source/opt/ssa_rewrite_pass.cpp",
    "source/opt/strength_reduction_pass.cpp",
    "source/opt/strip_debug_info_pass.cpp",
    "source/opt/strip_nonsemantic_info_pass.cpp",
    "source/opt/struct_cfg_analysis.cpp",
    "source/opt/switch_descriptorset_pass.cpp",
    "source/opt/trim_capabilities_pass.cpp",
    "source/opt/type_manager.cpp",
    "source/opt/types.cpp",
    "source/opt/unify_const_pass.cpp",
    "source/opt/upgrade_memory_model.cpp",
    "source/opt/value_number_table.cpp",
    "source/opt/vector_dce.cpp",
    "source/opt/workaround1209.cpp",
    "source/opt/wrap_opkill.cpp",

    "source/val/validate_ray_query.cpp",
    "source/val/validate_instruction.cpp",
    "source/val/validate_derivatives.cpp",
    "source/val/validate_primitives.cpp",
    "source/val/validate_debug.cpp",
    "source/val/validate_cfg.cpp",
    "source/val/validate_bitwise.cpp",
    "source/val/validate_non_uniform.cpp",
    "source/val/validate_scopes.cpp",
    "source/val/validate_interfaces.cpp",
    "source/val/validation_state.cpp",
    "source/val/validate_function.cpp",
    "source/val/validate_builtins.cpp",
    "source/val/validate_ray_tracing_reorder.cpp",
    "source/val/construct.cpp",
    "source/val/validate_mesh_shading.cpp",
    "source/val/function.cpp",
    "source/val/validate_memory.cpp",
    "source/val/validate_composites.cpp",
    "source/val/validate_misc.cpp",
    "source/val/validate_atomics.cpp",
    "source/val/validate_conversion.cpp",
    "source/val/basic_block.cpp",
    "source/val/validate_type.cpp",
    "source/val/validate_extensions.cpp",
    "source/val/validate_execution_limitations.cpp",
    "source/val/validate.cpp",
    "source/val/validate_logicals.cpp",
    "source/val/validate_small_type_uses.cpp",
    "source/val/validate_annotation.cpp",
    "source/val/validate_arithmetics.cpp",
    "source/val/validate_barriers.cpp",
    "source/val/validate_ray_tracing.cpp",
    "source/val/validate_capability.cpp",
    "source/val/validate_constants.cpp",
    "source/val/validate_layout.cpp",
    "source/val/instruction.cpp",
    "source/val/validate_image.cpp",
    "source/val/validate_literals.cpp",
    "source/val/validate_adjacency.cpp",
    "source/val/validate_decorations.cpp",
    "source/val/validate_id.cpp",
    "source/val/validate_mode_setting.cpp",
    "source/val/validate_memory_semantics.cpp",

    "source/util/bit_vector.cpp",
    "source/util/string_utils.cpp",
    "source/util/parse_number.cpp",
    "source/util/timer.cpp",
};
