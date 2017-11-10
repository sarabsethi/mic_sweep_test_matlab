# mic_sweep_test_matlab

Test a microphone's frequency response to a logarithmic sinus sweep

## Scripts
`sine_sweep.m` - Plays a logarithmic sinus sweep between 20Hz and 20kHz through the speakers, records from a microphone input (or integrated microphone) and calculates the frequency response of the microphone to the signal

`compare_results.m` - compare the mean frequency response between two tests

### Example output plot:
20Hz to 20kHz response measured from Rode SmartLav+ lavellier microphone brand new, then after a 3 week deployment in a recorder placed in a tropical rainforest
![Example comparing frequency response changes over time](https://raw.githubusercontent.com/sarabsethi/mic_sweep_test_matlab/master/example_compare_tests.png)

## Notes 
This isn't quite the same as calculating impulse response as there is no inverse signal or proper calibration, but it is useful for calculating how the frequency response changes over time. For example, in our case we used it to see how long term exposure to a tropical rainforest environment (high temperature, high humidity) changes the microphone's response.

Different test signals can be easily generated using [Audacity](www.audacityteam.org) with the Aurora plugin

## Author
[Sarab Sethi](http://www.imperial.ac.uk/people/s.sethi16) (Imperial College London)
