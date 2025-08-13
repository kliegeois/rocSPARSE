pwd_path=`pwd`

if [ ! -d "$pwd_path/build/release" ]; then
    ./install.sh -c -a gfx942
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

cd $pwd_path

python3 $pwd_path/read_python.py
