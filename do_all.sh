pwd_path=`pwd`

if [ ! -d "$pwd_path/build/release" ]; then
    yum install python38
    pip3.8 install -r /opt/rocm-7.0.0/libexec/rocprofiler-compute/requirements.txt
    ./install.sh -c -a gfx9420
else
    cd $pwd_path/build/release
    make -j 10
fi

cd $pwd_path/scripts/performance/matrices
./build_convert.sh
./get_matrices_1.sh

cd $pwd_path/build/release/clients/staging

rm -rf $pwd_path/log.txt

for i in {1..100}; do
    ./rocsparse-bench -f csrmv --precision s --device 0 --alpha 1 --beta 0 --iters 20 --rocalution $pwd_path/scripts/performance/matrices/mc2depi.csr | grep "NT             " >> $pwd_path/log.txt
done


cd $pwd_path/build/release/clients/staging

rm -rf $pwd_path/log_prof.txt
rm -rf pmc_*

#for i in {1..100}; do
#    rocprofv2 --plugin file -o csrmv_mc2depi_${i} -i ${pwd_path}/counters.txt ./rocsparse-bench --transposeA N -f csrmv --precision s --device 0 --alpha 1 --beta 0 --iters 20 --rocalution $pwd_path/scripts/performance/matrices/mc2depi.csr >> $pwd_path/log_prof.txt
#done

rm -rf $pwd_path/pmc_*

cp -r pmc_* $pwd_path/.

cd $pwd_path


for i in {1..20}; do
    python3.8 /opt/rocm-7.0.0/bin/rocprof-compute profile -n csrmv_mc2depi_${i} -- .$pwd_path/build/release/clients/staging/rocsparse-bench --transposeA N -f csrmv --precision s --device 0 --alpha 1 --beta 0 --iters 20 --rocalution $pwd_path/scripts/performance/matrices/mc2depi.csr >> $pwd_path/log_prof.txt
done

tar -cvzf results.tar.gz pmc_* log.txt log_prof.txt

python3 $pwd_path/read_python.py
