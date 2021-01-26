#FRTFLAGS = -convert big_endian -assume byterecl -traceback -qopenmp -qopenmp-threadprivate compat -fPIC  -align array64byte
#OPT_FRTFLAGS = -fp-model source -g -O2 -ip -xAVX -ftz  -fast-transcendentals

FRTFLAGS = -convert big_endian -assume byterecl -traceback -qopenmp -qopenmp-threadprivate compat -fPIC -r8
#OPT_FRTFLAGS = -fp-model source -g -O2 -ip -xAVX
OPT_FRTFLAGS = -fp-model source -g -O2 -ip -check bounds -debug full

#FC = /home/gmap/mrpm/marguina/install/gmkpack_support/wrapper/I185274/ifort $(FRTFLAGS) $(OPT_FRTFLAGS)
FC = /home/gmap/mrpm/marguina/install/gmkpack_support/wrapper/I185274/ifort $(FRTFLAGS) -g -O0

#FC = pgf90 -DCPU  -mp -byteswapio -Mlarge_arrays


all: wrap_rain_ice.x

%.o: %.F90
	$(FC) -o $@ -c $< 

parkind1.o: parkind1.F90 
	$(FC) -c parkind1.F90

xrd_getoptions.o: xrd_getoptions.F90 xrd_unix_env.o parkind1.o
	$(FC) -c xrd_getoptions.F90

xrd_unix_env.o: xrd_unix_env.F90 parkind1.o
	$(FC) -c xrd_unix_env.F90

load_mod.o: load_mod.F90 parkind1.o
	$(FC) -c load_mod.F90

modd_budget.o: modd_budget.F90 modd_parameters.o
	$(FC) -c modd_budget.F90

modd_les.o: modd_les.F90 modd_parameters.o
	$(FC) -c modd_les.F90

rain_ice_load_all.o: rain_ice_load_all.F90 load_mod.o modd_budget.o modd_les.o modd_rain_ice_descr.o  modd_rain_ice_param.o modd_cst.o modd_param_ice.o
	$(FC) -c rain_ice_load_all.F90

rain_ice.o: rain_ice.F90 modd_budget.o modd_cst.o modd_les.o modd_parameters.o modd_param_ice.o modd_rain_ice_descr.o modd_rain_ice_param.o modi_ice4_nucleation_wrapper.o modi_ice4_rainfr_vert.o modi_ice4_sedimentation_split.o modi_ice4_sedimentation_stat.o modi_ice4_tendencies.o
	$(FC) -c rain_ice.F90

wrap_rain_ice.o: wrap_rain_ice.F90 load_mod.o xrd_unix_env.o xrd_getoptions.o modi_rain_ice.o contains.h
	$(FC) -c wrap_rain_ice.F90

ice4_sedimentation_stat.o: ice4_sedimentation_stat.F90 modd_cst.o modd_budget.o modi_gamma.o modd_rain_ice_descr.o modd_rain_ice_param.o
	$(FC) -c ice4_sedimentation_stat.F90

ice4_sedimentation_split.o: ice4_sedimentation_split.F90 modd_cst.o modd_param_ice.o modd_rain_ice_descr.o modd_rain_ice_param.o modi_gamma.o
	$(FC) -c ice4_sedimentation_split.F90

ice4_tendencies.o: ice4_tendencies.F90 modd_cst.o modd_param_ice.o modd_rain_ice_descr.o modd_rain_ice_param.o modi_ice4_compute_pdf.o modi_ice4_fast_rg.o modi_ice4_fast_rh.o modi_ice4_fast_ri.o modi_ice4_fast_rs.o modi_ice4_nucleation.o modi_ice4_rainfr_vert.o modi_ice4_rimltc.o modi_ice4_rrhong.o modi_ice4_rsrimcg_old.o modi_ice4_slow.o modi_ice4_warm.o
	$(FC) -c ice4_tendencies.F90

ice4_nucleation_wrapper.o: ice4_nucleation_wrapper.F90 modd_cst.o
	$(FC) -c ice4_nucleation_wrapper.F90

ice4_nucleation.o: ice4_nucleation.F90 modd_cst.o modd_rain_ice_param.o modd_rain_ice_descr.o modd_param_ice.o
	$(FC) -c ice4_nucleation.F90

ice4_rainfr_vert.o: ice4_rainfr_vert.F90 modd_rain_ice_descr.o
	$(FC) -c ice4_rainfr_vert.F90

ice4_rrhong.o: ice4_rrhong.F90 modd_cst.o modd_rain_ice_param.o modd_rain_ice_descr.o modd_param_ice.o
	$(FC) -c ice4_rrhong.F90

ice4_rimltc.o: ice4_rimltc.F90 modd_cst.o modd_rain_ice_param.o modd_rain_ice_descr.o modd_param_ice.o
	$(FC) -c ice4_rimltc.F90

ice4_rsrimcg_old.o: ice4_rsrimcg_old.F90 modd_cst.o modd_rain_ice_param.o modd_rain_ice_descr.o modd_param_ice.o
	$(FC) -c ice4_rsrimcg_old.F90

ice4_compute_pdf.o: ice4_compute_pdf.F90 modd_rain_ice_descr.o modd_rain_ice_param.o
	$(FC) -c ice4_compute_pdf.F90

ice4_slow.o: ice4_slow.F90 modd_rain_ice_descr.o modd_rain_ice_param.o modd_cst.o
	$(FC) -c ice4_slow.F90

ice4_warm.o: ice4_warm.F90 modd_rain_ice_descr.o modd_rain_ice_param.o modd_cst.o
	$(FC) -c ice4_warm.F90

ice4_fast_rs.o: ice4_fast_rs.F90 modd_rain_ice_descr.o modd_rain_ice_param.o modd_cst.o modd_param_ice.o
	$(FC) -c ice4_fast_rs.F90

ice4_fast_rg.o: ice4_fast_rg.F90 modd_rain_ice_descr.o modd_rain_ice_param.o modd_cst.o modd_param_ice.o
	$(FC) -c ice4_fast_rg.F90

ice4_fast_rh.o: ice4_fast_rh.F90 modd_rain_ice_descr.o modd_rain_ice_param.o modd_cst.o modd_param_ice.o
	$(FC) -c ice4_fast_rh.F90

ice4_fast_ri.o: ice4_fast_ri.F90 modd_rain_ice_descr.o modd_rain_ice_param.o modd_cst.o modd_param_ice.o
	$(FC) -c ice4_fast_ri.F90

wrap_rain_ice.x: rain_ice_load_all.o wrap_rain_ice.o load_mod.o xrd_unix_env.o xrd_getoptions.o modd_budget.o modd_les.o modd_rain_ice_descr.o  modd_rain_ice_param.o modd_cst.o modd_param_ice.o rain_ice.o ice4_sedimentation_stat.o ice4_sedimentation_split.o ice4_tendencies.o ice4_nucleation_wrapper.o gamma.o ice4_nucleation.o ice4_rrhong.o ice4_rainfr_vert.o ice4_rimltc.o ice4_rsrimcg_old.o ice4_compute_pdf.o ice4_slow.o ice4_warm.o ice4_fast_rs.o ice4_fast_rg.o ice4_fast_rh.o ice4_fast_ri.o
	$(FC) -o wrap_rain_ice.x rain_ice_load_all.o wrap_rain_ice.o load_mod.o xrd_unix_env.o xrd_getoptions.o modd_budget.o modd_les.o modd_rain_ice_descr.o  modd_rain_ice_param.o modd_cst.o modd_param_ice.o rain_ice.o ice4_sedimentation_stat.o ice4_sedimentation_split.o ice4_tendencies.o ice4_nucleation_wrapper.o gamma.o ice4_nucleation.o ice4_rrhong.o ice4_rainfr_vert.o ice4_rimltc.o ice4_rsrimcg_old.o ice4_compute_pdf.o ice4_slow.o ice4_warm.o ice4_fast_rs.o ice4_fast_rg.o ice4_fast_rh.o ice4_fast_ri.o

clean:
	\rm -f *.o *.x *.mod *.xml *.optrpt

