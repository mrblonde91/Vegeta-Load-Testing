# Vegeta-Load-Testing
* `docker-compose up` in docker-compose folder. Can use environment variables to change up requests. 

Sample commands with traffic generator(need vegeta installed)

    dotnet run | vegeta attack -lazy -rate=10 -duration=1m | tee results.bin | vegeta report -type=text

    dotnet run | vegeta attack -lazy -rate=10 -duration=1m | tee results2.bin | vegeta report -type="hist[0,1ms,100ms,200ms]"
    
    
## Resources
[Vegeta source code](https://github.com/tsenart/vegeta)
