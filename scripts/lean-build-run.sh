cd /Lean
echo "Preparing packages..."
nuget restore QuantConnect.Lean.sln | tee /Lean/Results/nuget-restore.log.txt
echo "Building source code..."
msbuild QuantConnect.Lean.sln | tee /Lean/Results/build.log.txt
cd /Lean/Launcher/bin/Debug
echo "Executing source code..."
mono QuantConnect.Lean.Launcher.exe | tee /Lean/Results/output.txt
